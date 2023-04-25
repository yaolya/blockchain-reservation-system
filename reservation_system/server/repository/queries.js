const db = require('./db')
var bcrypt = require('bcryptjs');
const saltRounds = 10;

async function getAllUsers() {
    return await db.all("SELECT * FROM users", []);
}

async function getUserById(userId) {
    return await db.get("SELECT * FROM users WHERE userId = ?", [userId]);
}

async function getUserByEmail(email) {
    return await db.get("SELECT * FROM users WHERE email = ?", [email]);
}

async function createUser(userId, email, password) {
    return await db.run("INSERT INTO users (userId, email, password) VALUES (?,?,?)", [userId, email, password]);
}

async function updateUser(userId, email, password) {
    return await db.run("UPDATE users SET email=?, password=? WHERE userId=?", [email, password, userId])
}

async function deleteUser(userId) {
    return await db.run("DELETE FROM users WHERE userId =  ?", [userId])
}

module.exports = {
    getAllUsers,
    getUserById,
    getUserByEmail,
    createUser,
    updateUser,
    deleteUser
}