'use strict';

const itemsContract = require('./lib/itemsContract');
const userContract = require('./lib/userContract');
const groupContract = require('./lib/groupContract');

module.exports.ItemsContract = itemsContract;
module.exports.UserContract = userContract;
module.exports.GroupContract = groupContract;
module.exports.contracts = [itemsContract, userContract, groupContract];
