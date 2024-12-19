const mysql = require('mysql2');
require('dotenv').config();

const connection = mysql
    .createConnection({
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        database: process.env.DB_DATABASE,
        // ssl: {
        //     rejectUnauthorized: true,
        //     // ca: fs.readFileSync('./ca.pem').toString(), // Đường dẫn đến chứng chỉ ca.pem
        //     ca: process.env.DB_CA,
        // },
    })
    .promise();

connection.connect((err) => {
    if (err) {
        console.error('Error connecting: ' + err.stack);
        return;
    }
    console.log('Connected as id ' + connection.threadId);
});

module.exports = connection;
