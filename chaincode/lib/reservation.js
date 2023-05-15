'use strict';

class Reservation {
    /**
     *
     * Reservation
     *
     * Constructor for a Reservation object.
     *  
     * @param reservationId - unique Id which corresponds to a created Reservation
     * @param itemId - id of the reserved item
     * @param userId - id of a Reservation creator
     * @returns - Reservation object
     */
    constructor(reservationId, itemId, userId) {

        this.reservationId = reservationId;
        this.itemId = itemId;
        this.userId = userId;
        this.type = 'reservation';
        if (this.__isContract) {
            delete this.__isContract;
        }
        return this;

    }

}
module.exports = Reservation;