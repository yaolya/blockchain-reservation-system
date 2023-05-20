'use strict';

const stringify = require('json-stringify-deterministic');
const { Contract } = require('fabric-contract-api');

let Item = require('./item.js');
let Reservation = require('./reservation.js');
let GroupContract = require('./groupContract.js');
let ReservationContract = require('./reservationContract.js');

class ItemsContract extends Contract {

    async CreateItem(ctx, itemId, name, description, price, cancellation, rebooking, groupId, providerId) {

        let item = new Item(itemId, name, description, price, cancellation, rebooking, groupId, providerId);
        const groupString = await GroupContract.ReadGroup(ctx, groupId);
        const group = JSON.parse(groupString);
        group.numberOfItems += 1;

        await ctx.stub.putState(group.groupId, Buffer.from(stringify(group)));
        await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
        return JSON.stringify(item, group);
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

    async UpdateItem(ctx, itemId, name, description, price, cancellation, rebooking, groupId, providerId) {
        const exists = await this.ItemExists(ctx, itemId);
        if (!exists) {
            throw new Error(`The item ${itemId} does not exist`);
        }

        let updatedItem = new Item(itemId, name, description, price, cancellation, rebooking, groupId, providerId);

        await ctx.stub.putState(updatedItem.itemId, Buffer.from(stringify(updatedItem)));
        return JSON.stringify(updatedItem);
    }

    async ReserveItem(ctx, itemId, newOwnerId, currentUserId, reservationId) {
        const itemString = await this.ReadItem(ctx, itemId);
        const item = JSON.parse(itemString);
        const groupString = await GroupContract.ReadGroup(ctx, item.groupId);
        const group = JSON.parse(groupString);
        if ((group.numberOfReservations + 1) / group.numberOfItems < (group.overbooking / 100 + 1)) {
            group.numberOfReservations += 1;
            item.ownerId = newOwnerId;
            await ReservationContract.CreateReservation(ctx, reservationId, itemId, currentUserId);
            await ctx.stub.putState(group.groupId, Buffer.from(stringify(group)));
            await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
            return JSON.stringify({ "newOwnerId": newOwnerId });
        } else {
            throw new Error(`The item ${itemId} is already reserved`);
        }
    }

    async TransferItem(ctx, itemId, newOwnerId, currentUserId) {
        const itemString = await this.ReadItem(ctx, itemId);
        const item = JSON.parse(itemString);
        if (item.rebooking == "true" && item.ownerId == currentUserId) {
            const reservationArray = await this.GetReservation(ctx, currentUserId, itemId);
            const reservation = JSON.parse(reservationArray)[0].Record;
            reservation.userId = newOwnerId;
            await ctx.stub.putState(reservation.reservationId, Buffer.from(stringify(reservation)));
            item.ownerId = newOwnerId;
            await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
            return JSON.stringify(reservation);
        } else {
            throw new Error(`The item ${itemId} cannot be transferred`);
        }
    }

    async CancelItemReservation(ctx, userId, itemId) {
        const itemString = await this.ReadItem(ctx, itemId);
        const item = JSON.parse(itemString);
        const groupString = await GroupContract.ReadGroup(ctx, item.groupId);
        const group = JSON.parse(groupString);
        if (item.cancellation == "true" && item.ownerId != null) {
            const reservationArray = await this.GetReservation(ctx, userId, itemId);
            const reservation = JSON.parse(reservationArray)[0].Record;
            await ReservationContract.DeleteReservation(ctx, reservation.reservationId);
            item.ownerId = null;
            group.numberOfReservations -= 1;
            await ctx.stub.putState(group.groupId, Buffer.from(stringify(group)));
            await ctx.stub.putState(item.itemId, Buffer.from(stringify(item)));
            return JSON.stringify(item);
        } else {
            throw new Error(`The item ${itemId} reservation cannot be cancelled`);
        }
    }

    async DeleteItem(ctx, itemId) {
        const exists = await this.ItemExists(ctx, itemId);
        const itemString = await this.ReadItem(ctx, itemId);
        const item = JSON.parse(itemString);
        const groupString = await GroupContract.ReadGroup(ctx, item.groupId);
        const group = JSON.parse(groupString);
        if (!exists) {
            throw new Error(`The item ${itemId} does not exist`);
        }
        group.numberOfItems -= 1;
        await ctx.stub.putState(group.groupId, Buffer.from(stringify(group)));
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

    async GetAllGroups(ctx) {
        let queryString = {
            selector: {
                type: 'group'
            }
        };

        let queryResults = await this.query(ctx, stringify(queryString));
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

    async GetUserCreatedGroups(ctx, userId) {
        let queryString = {
            selector: {
                type: 'group',
                userId: userId
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return queryResults;
    }

    async GetReservation(ctx, userId, itemId) {
        let queryString = {
            selector: {
                type: 'reservation',
                userId: userId,
                itemId: itemId
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return JSON.stringify(JSON.parse(queryResults.toString()));
    }

    async GetItemReservations(ctx, itemId) {
        let queryString = {
            selector: {
                type: 'reservation',
                itemId: itemId
            }
        };

        let queryResults = await this.query(ctx, JSON.stringify(queryString));
        return queryResults;
    }

    async GetItemsByGroup(ctx, groupId) {
        let queryString = {
            selector: {
                type: 'item',
                groupId: groupId
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

    async query(ctx, queryString) {

        let resultsIterator = await ctx.stub.getQueryResult(queryString);
        var results = this._GetAllResults(resultsIterator, false);
        return results;
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
}

module.exports = ItemsContract;
