'use strict';

const stringify = require('json-stringify-deterministic');
const { Contract } = require('fabric-contract-api');

let Group = require('./group.js');

class GroupContract extends Contract {

    async CreateGroup(ctx, groupId, name, description, overbooking, userId) {
        let group = new Group(groupId, name, description, overbooking, 0, 0, userId);

        await ctx.stub.putState(group.groupId, Buffer.from(stringify(group)));
        return JSON.stringify(group);
    }

    static async ReadGroup(ctx, groupId) {
        const groupJSON = await ctx.stub.getState(groupId);
        if (!groupJSON || groupJSON.length === 0) {
            throw new Error(`The group ${groupId} does not exist`);
        }
        return groupJSON.toString();
    }

    async UpdateGroup(ctx, groupId, name, description, overbooking, numberOfItems, numberOfReservations, userId) {
        const exists = await this.GroupExists(ctx, groupId);
        if (!exists) {
            throw new Error(`The group ${groupId} does not exist`);
        }

        let updatedGroup = new Group(groupId, name, description, overbooking, numberOfItems, numberOfReservations, userId);

        return ctx.stub.putState(updatedGroup.groupId, Buffer.from(stringify(updatedGroup)));
    }

    async DeleteGroup(ctx, groupId) {
        const exists = await this.GroupExists(ctx, groupId);
        if (!exists) {
            throw new Error(`The group ${groupId} does not exist`);
        }
        return ctx.stub.deleteState(groupId);
    }

    async GroupExists(ctx, groupId) {
        const groupJSON = await ctx.stub.getState(groupId);
        return groupJSON && groupJSON.length > 0;
    }

}

module.exports = GroupContract;