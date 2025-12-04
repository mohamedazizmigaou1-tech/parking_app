const { Pool } = require('pg');
const path = require('path');

const envPath = path.join('../.env');
console.log('Loading .env from:', envPath);

require('dotenv').config({ path: envPath });

const pool = new Pool({
    host: process.env.PGHOST,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    database: process.env.PGDATABASE,
    port: process.env.PGPORT,
    ssl: {
      rejectUnauthorized: false // obligatoire pour Railway
    }
  });
  

pool.connect((err, client, release) => {
    if (err) {
        console.error('Error connecting to PostgreSQL: ' + process.env.PGPASSWORD + ' ' , err.message);
    } else {
        console.log('Successfully connected to PostgreSQL database');
        release();
    }
});

module.exports = {
    query: (text, params) => pool.query(text, params),
    pool
};