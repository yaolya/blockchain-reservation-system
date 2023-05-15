'use strict';

const stringify = require('json-stringify-deterministic');
const { Contract } = require('fabric-contract-api');

let Reservation = require('./reservation.js');

class ReservationContract extends Contract {

    static async CreateReservation(ctx, reservationId, itemId, userId) {
        let reservation = new Reservation(reservationId, itemId, userId);
        await ctx.stub.putState(reservation.reservationId, Buffer.from(stringify(reservation)));
    }

    static async ReadReservation(ctx, reservationId) {
        const reservationJSON = await ctx.stub.getState(reservationId);
        if (!reservationJSON || reservationJSON.length === 0) {
            throw new Error(`The reservation ${reservationId} does not exist`);
        }
        return reservationJSON.toString();
    }

    static async UpdateReservation(ctx, reservationId, itemId, userId) {

        let updatedReservation = new Reservation(reservationId, itemId, userId);

        await ctx.stub.putState(updatedReservation.reservationId, Buffer.from(stringify(updatedReservation)));
    }

    static async DeleteReservation(ctx, reservationId) {
        await ctx.stub.deleteState(reservationId);
    }

}

module.exports = ReservationContract;