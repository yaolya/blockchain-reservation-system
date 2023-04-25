'use strict';

const stringify = require('json-stringify-deterministic');
const { Contract } = require('fabric-contract-api');

let Item = require('./item.js');

class ItemsContract extends Contract {

    async CreateItem(ctx, itemId, name, description, price, cancellation, rebooking, providerId) {

        let item = new Item(itemId, name, description, price, cancellation, rebooking, providerId);

        await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
        return JSON.stringify(item);
    }

    async ReadItem(ctx, id) {
        const itemJSON = await ctx.stub.getState(id);
        if (!itemJSON || itemJSON.length === 0) {
            throw new Error(`The item ${id} does not exist`);
        }
        return itemJSON.toString();
    }

    async GetItemHistory(ctx, id) {

        let resultsIterator = await ctx.stub.getHistoryForKey(id);
        let results = await this._GetAllResults(resultsIterator, true);

        return results;

    }

    async UpdateItem(ctx, itemId, name, description, price, cancellation, rebooking, providerId) {
        const exists = await this.ItemExists(ctx, itemId);
        if (!exists) {
            throw new Error(`The item ${itemId} does not exist`);
        }

        let updatedItem = new Item(itemId, name, description, price, cancellation, rebooking, providerId);

        await ctx.stub.putState(updatedItem.itemId, Buffer.from(stringify(updatedItem)));
        return JSON.stringify(updatedItem);
    }

    async ReserveItem(ctx, itemId, newOwnerId) {
        const itemString = await this.ReadItem(ctx, itemId);
        const item = JSON.parse(itemString);
        if (item.ownerId == null) {
            item.ownerId = newOwnerId;
            await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
            return JSON.stringify({ "newOwnerId": newOwnerId });
        } else if (item.rebooking == "true") {
            const oldOwnerId = item.ownerId;
            item.ownerId = newOwnerId;
            await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
            return JSON.stringify({
                "newOwnerId": newOwnerId,
                "oldOwnerId": oldOwnerId
            });
        } else {
            throw new Error(`The item ${itemId} is already reserved`);
        }
    }

    async CancelItemReservation(ctx, itemId) {
        const itemString = await this.ReadItem(ctx, itemId);
        const item = JSON.parse(itemString);
        if (item.cancellation == "true" && item.ownerId != null) {
            item.ownerId = null;
            await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
            return JSON.stringify(item);
        } else {
            throw new Error(`The item ${itemId} reservation cannot be cancelled`);
        }
    }

    async DeleteItem(ctx, itemId) {
        const exists = await this.ItemExists(ctx, itemId);
        if (!exists) {
            throw new Error(`The item ${itemId} does not exist`);
        }
        return ctx.stub.deleteState(itemId);
    }

    async ItemExists(ctx, itemId) {
        const itemJSON = await ctx.stub.getState(itemId);
        return itemJSON && itemJSON.length > 0;
    }

    async GetAllItems(ctx) {
        let queryString = {
            selector: {
                type: 'item'
            }
        };

        let queryResults = await this.query(ctx, stringify(queryString));
        return queryResults;

    }

    async GetAllUsers(ctx) {
        let queryString = {
            selector: {
                type: 'user'
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return queryResults;

    }

    async GetAvailableItems(ctx) {
        let queryString = {
            selector: {
                ownerId: null
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return queryResults;
    }

    async GetUserCreatedItems(ctx, providerId) {
        let queryString = {
            selector: {
                providerId: providerId
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return queryResults;
    }

    async GetUserReservedItems(ctx, ownerId) {
        let queryString = {
            selector: {
                ownerId: ownerId
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return queryResults;
    }

    async _GetAllResults(iterator, isHistory) {
        let allResults = [];
        let res = await iterator.next();
        while (!res.done) {
            if (res.value && res.value.value.toString()) {
                let jsonRes = {};
                console.log(res.value.value.toString('utf8'));
                if (isHistory && isHistory === true) {
                    jsonRes.TxId = res.value.txId;
                    jsonRes.Timestamp = res.value.timestamp;
                    try {
                        jsonRes.Value = JSON.parse(res.value.value.toString('utf8'));
                    } catch (err) {
                        console.log(err);
                        jsonRes.Value = res.value.value.toString('utf8');
                    }
                } else {
                    jsonRes.Key = res.value.key;
                    try {
                        jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
                    } catch (err) {
                        console.log(err);
                        jsonRes.Record = res.value.value.toString('utf8');
                    }
                }
                allResults.push(jsonRes);
            }
            res = await iterator.next();
        }
        iterator.close();
        return stringify(allResults);
    }

    async query(ctx, queryString) {

        let resultsIterator = await ctx.stub.getQueryResult(queryString);
        var results = this._GetAllResults(resultsIterator, false);
        return results;
    }
}

module.exports = ItemsContract;
