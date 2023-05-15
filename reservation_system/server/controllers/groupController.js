const helper = require('../helper')
const network = require('../network')


async function groupAlreadyExists(email) {
    try {
        return await queries.getGroupById(email);
    } catch (e) {
        console.log(e);
    }
}

class GroupController {

    async getAll(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetAllGroups');
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getAllByCreator(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'ItemsContract');

            let result = await contract.evaluateTransaction('GetUserCreatedGroups', req.params.id);
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async getById(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'GroupContract');

            let result = await contract.evaluateTransaction('ReadGroup', req.params.id);
            res.send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            console.log(e);
        }
    }

    async create(req, res) {
        try {
            const groupId = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
            const { gateway, contract } = await network.createConnection(req.user.userId, 'GroupContract');

            let result = await contract.submitTransaction('CreateGroup',
                groupId,
                req.body["name"],
                req.body["description"],
                req.body["overbooking"],
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
            const { gateway, contract } = await network.createConnection(req.user.userId, 'GroupContract');

            let r = await contract.submitTransaction('UpdateGroup',
                req.body["groupId"],
                req.body["name"],
                req.body["description"],
                req.body["overbooking"],
                req.body["numberOfItems"],
                req.body["numberOfReservations"],
                req.user.userId
            ); 
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }

    async delete(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'GroupContract');

            let r = await contract.submitTransaction('DeleteGroup', req.params.id);
            res.status(200).send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            res.status(400).send(e);
        }
    }
}

module.exports = new GroupController()