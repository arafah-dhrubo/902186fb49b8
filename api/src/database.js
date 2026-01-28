const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');

const DB_PATH = path.join(__dirname, '..', 'vitals.db');

// Ensure the database file exists before opening it
if (!fs.existsSync(DB_PATH)) {
    console.log('Database file not found. Creating vitals.db...');
    fs.closeSync(fs.openSync(DB_PATH, 'w'));
}

const db = new sqlite3.Database(DB_PATH, (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
    } else {
        console.log('Connected to the SQLite database.');
        initializeDatabase();
    }
});

const initializeDatabase = () => {
    db.serialize(() => {
        db.run(`CREATE TABLE IF NOT EXISTS vitals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_id TEXT NOT NULL,
            timestamp TEXT NOT NULL,
            thermal_value REAL NOT NULL,
            battery_level REAL NOT NULL,
            memory_usage REAL NOT NULL
        )`);
    });
};

const closeDatabase = () => {
    return new Promise((resolve, reject) => {
        db.close((err) => {
            if (err) {
                console.error('Error closing database:', err.message);
                reject(err);
            } else {
                console.log('Database connection closed.');
                resolve();
            }
        });
    });
};

module.exports = { db, closeDatabase };
