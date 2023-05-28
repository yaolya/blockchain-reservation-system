'use strict';

class Item {
    /**
     *
     * Item
     *
     * Constructor for an Item object.
     *  
     * @param itemId - unique Id which corresponds to a created Item
     * @param name - Item name
     * @param description - Item description
     * @param price - Item price
     * @param cancellation - true if cancellation is allowed otherwise false
     * @param rebooking - true if rebooking is allowed otherwise false
     * @param groupId - id of a group of items
     * @param providerId - id of an Item's provider
     * @returns - Item object
     */
    constructor(itemId, name, description, price, cancellation, rebooking, groupId, providerId) {

        this.itemId = itemId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.cancellation = cancellation;
        this.rebooking = rebooking;
        this.groupId = groupId;
        this.providerId = providerId;
        this.type = 'item';
        if (this.__isContract) {
            delete this.__isContract;
        }
        return this;

    }

}
module.exports = Item;