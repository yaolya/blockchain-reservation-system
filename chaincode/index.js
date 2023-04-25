'use strict';

const itemsContract = require('./lib/itemsContract');
const userContract = require('./lib/userContract');

module.exports.ItemsContract = itemsContract;
module.exports.UserContract = userContract;
module.exports.contracts = [itemsContract, userContract];
