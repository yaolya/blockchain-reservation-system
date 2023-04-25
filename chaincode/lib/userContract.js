'use strict';

const stringify = require('json-stringify-deterministic');
const { Contract } = require('fabric-contract-api');

let User = require('./user.js');

class UserContract extends Contract {

    async CreateUser(ctx, userId, email, overbooking) {

        let user = new User(userId, email, overbooking);

        await ctx.stub.putState(user.userId, Buffer.from(stringify(user)));
        return JSON.stringify(user);
    }

    async ReadUser(ctx, userId) {
        const userJSON = await ctx.stub.getState(userId);
        if (!userJSON || userJSON.length === 0) {
            throw new Error(`The user ${userId} does not exist`);
        }
        return userJSON.toString();
    }

    async UpdateUser(ctx, userId, email, overbooking) {
        const exists = await this.UserExists(ctx, userId);
        if (!exists) {
            throw new Error(`The user ${userId} does not exist`);
        }

        let updatedUser = new User(userId, email, overbooking);

        return ctx.stub.putState(updatedUser.userId, Buffer.from(stringify(updatedUser)));
    }

    async DeleteUser(ctx, userId) {
        const exists = await this.UserExists(ctx, userId);
        if (!exists) {
            throw new Error(`The user ${userId} does not exist`);
        }
        return ctx.stub.deleteState(userId);
    }

    async UserExists(ctx, userId) {
        const userJSON = await ctx.stub.getState(userId);
        return userJSON && userJSON.length > 0;
    }

}

module.exports = UserContract;