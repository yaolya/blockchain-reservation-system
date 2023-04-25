const sqlite3 = require('sqlite3').verbose();

const path = require('path')
const DBSOURCE = path.resolve(__dirname, "users.db")
const db = new sqlite3.Database(DBSOURCE, (err) => {
    if (err) {
        console.error(err.message)
        throw err
    }
});

function setupDb() {
    db.serialize(function () {
        const createUsersTable = "CREATE TABLE IF NOT EXISTS users (userId TEXT PRIMARY KEY, email TEXT, password TEXT)";
        db.run(createUsersTable);
    });
}

function run(sql, params) {
    return new Promise((resolve, reject) => {
        db.run(sql, params, (err, result) => {
            if (err) {
                reject(err);
            }
            resolve(result)
        });
    });
}

function all(sql, params) {
    return new Promise((resolve, reject) => {
        db.all(sql, params, (err, result) => {
            if (err) {
                reject(err);
            }
            resolve(result)
        });
    });
}

function get(sql, params) {
    return new Promise((resolve, reject) => {
        db.get(sql, params, (err, result) => {
            if (err) {
                reject(err);
            }
            resolve(result)
        });
    });
}

function close() {
    db.close();
}

module.exports = {
    setupDb,
    run,
    get,
    all,
    close
}