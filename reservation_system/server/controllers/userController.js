const { Gateway, Wallets } = require('fabric-network');
const helper = require('../helper')
const network = require('../network')
const queries = require('../repository/queries')
var bcrypt = require('bcryptjs');
const walletPath = './wallet';
const jwt = require('jsonwebtoken');
require('dotenv').config();
const ca = require('../caActions')

const generateJwt = (userId) => {
    return jwt.sign(
        { userId },
        process.env.TOKEN_KEY,
        { expiresIn: '24h' }
    )
}

async function userAlreadyExists(email) {
    try {
        return await queries.getUserByEmail(email);
    } catch (e) {
        console.log(e);
    }
}

class UserController {

    async register(req, res) {
        try {
            const { email, password } = req.body;
            var user = await userAlreadyExists(email);
            const wallet = await helper.buildWallet(Wallets, walletPath);

            if (user || await wallet.get(userId)) {
                return res.status(400).send("User Already Exist. Please Login");
            }

            var encryptedPassword = await bcrypt.hash(password, 10);

            var userId = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
            await queries.createUser(userId, email, encryptedPassword);
            await ca.getUser(userId);

            const { gateway, contract } = await network.createConnection(userId, 'UserContract');

            let result = await contract.submitTransaction('CreateUser',
                userId,
                req.body["email"]
            );
            res.status(200).send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();

        } catch (err) {
            console.log(err);
        }
    }

    async login(req, res) {
        try {
            const { email, password } = req.body;
            var user = await userAlreadyExists(email);
            const wallet = await helper.buildWallet(Wallets, walletPath);

            if (user && await wallet.get(user.userId) && (await bcrypt.compare(password, user.password))) {
                const token = generateJwt(user.userId);
                res.status(200).json({ "user": user, "token": token });
            } else {
                res.status(400).send("Invalid Credentials");
            }

        } catch (err) {
            console.log(err);
        }
    }

    async getById(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'UserContract');

            let result = await contract.evaluateTransaction('ReadUser', req.params.id);
            res.send(`${helper.JSONString(result.toString())}`);

            gateway.disconnect();
        } catch (e) {
            console.log(e);
        }
    }

    async getByEmail(req, res) {
        try {
            const { email } = req.body;
            let user = await queries.getUserByEmail(email);
            if (!user) {
                res.status(400).send();
            }
            res.status(200).send(user);
        } catch (e) {
            console.log(e);
        }
    }

    async update(req, res) {
        try {
            const { email, password } = req.body;
            const { gateway, contract } = await network.createConnection(req.user.userId, 'UserContract');

            let r = await contract.submitTransaction('UpdateUser',
            req.user.userId,
            email,
            0
            );
            var encryptedPassword = await bcrypt.hash(password, 10);
            await queries.updateUser(req.user.userId, email, encryptedPassword);
            res.send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            console.log(e);
        }
    }


    async delete(req, res) {
        try {
            const { gateway, contract } = await network.createConnection(req.user.userId, 'UserContract');

            let r = await contract.submitTransaction('DeleteUser', req.user.userId);
            await queries.deleteUser(req.user.userId);
            res.send(`${helper.JSONString(r.toString())}`);

            gateway.disconnect();
        } catch (e) {
            console.log(e);
        }
    }
}

module.exports = new UserController()