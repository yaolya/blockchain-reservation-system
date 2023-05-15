'use strict';

class Group {
    /**
     *
     * Group
     *
     * Constructor for a Group object.
     *  
     * @param groupId - unique Id which corresponds to a created Group
     * @param name - Group name
     * @param description - Group description
     * @param overbooking - allowed overbooking
     * @param numberOfItems - number of Items in a Group
     * @param numberOfReservations - number of reserved Items in a Group
     * @param userId - id of a Group creator
     * @returns - Group object
     */
    constructor(groupId, name, description, overbooking, numberOfItems, numberOfReservations, userId) {

        this.groupId = groupId;
        this.name = name;
        this.description = description;
        this.overbooking = overbooking;
        this.numberOfItems = numberOfItems;
        this.numberOfReservations = numberOfReservations;
        this.userId = userId;
        this.type = 'group';
        if (this.__isContract) {
            delete this.__isContract;
        }
        return this;

    }

}
module.exports = Group;