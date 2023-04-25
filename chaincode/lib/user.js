'use strict';

class User {
    /**
     *
     * User
     *
     * Constructor for a User object.
     *  
     * @param userId - unique Id which corresponds to a created User
     * @param email - User email
     * @param overbooking - percent of overbooking allowed for User's items
     * @returns - User object
     */
    constructor(userId, email, overbooking) {

        if (this.validateUser(userId)) {
            this.userId = userId;
            this.email = email;
            this.overbooking = overbooking;
            this.type = 'user';
            if (this.__isContract) {
                delete this.__isContract;
            }
            return this;

        } else {
            throw new Error('The userId is not valid.');
        }

    }

    /**
     *
     * validateUser
     *
     * check for some valid ID card
     *  
     * @param userId - the unique Id which corresponds to a registered User
     * @returns - true if valid User, false if invalid
     */
    async validateUser(userId) {
        if (userId) {
            return true;
        } else {
            return false;
        }
    }

}
module.exports = User;