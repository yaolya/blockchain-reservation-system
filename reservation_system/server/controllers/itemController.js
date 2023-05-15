const helper = require('../helper')
const network = require('../network')


class ItemController {

    async getAll(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetAllItems');
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getAvailable(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetAvailableItems');
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getAllByCreator(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetUserCreatedItems', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getItemReservations(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetItemReservations', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getAllByGroup(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetItemsByGroup', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getAllByOwner(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetUserReservedItems', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getById(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('ReadItem', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getHistoryById(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetItemHistory', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async create(req, res) {
        try {
            const itemId = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.submitTransaction('CreateItem',
                itemId,
                req.body["name"],
                req.body["description"],
                req.body["price"],
                req.body["cancellation"],
                req.body["rebooking"],
                req.body["groupId"],
                req.user.userId
            );
            res.status(200).send(`${helper.JSONString(result.toString() || '')}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async update(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let r = await contract.submitTransaction('UpdateItem',
                req.body["itemId"],
                req.body["name"],
                req.body["description"],
                req.body["price"],
                req.body["cancellation"],
                req.body["rebooking"],
                req.user.userId
            );
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async reserve(req, res) {
        try {
            const reservationId = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let r = await contract.submitTransaction('ReserveItem',
                req.body["itemId"],
                req.body["newOwnerId"],
                req.body["userId"],
                reservationId
            ); 
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getReservation(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let r = await contract.submitTransaction('GetReservation',
                req.body["userId"],
                req.body["itemId"]
            ); 
            console.log(r);
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async cancel(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let r = await contract.submitTransaction('CancelItemReservation', req.user.userId, req.body["itemId"]);
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async delete(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let r = await contract.submitTransaction('DeleteItem', req.params.id);
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

}

module.exports = new ItemController()