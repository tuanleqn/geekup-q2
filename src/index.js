require('dotenv').config();
const express = require('express');
const app = express();
const path = require('path');
const cors = require('cors');
const routes = require('./routes');
// const cookieParser = require('cookie-parser');
// const session = require('express-session');
const port = process.env.PORT;

app.use(
    cors({
        origin: process.env.CLIENT_URL,
        methods: ['GET', 'POST', 'PUT', 'DELETE'],
        allowedHeaders: ['Content-Type', 'Authorization'],
        credentials: true,
    }),
);

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());
// app.use(cookieParser());
// app.set('trust proxy', true);
// app.use(
//     session({
//         secret: 'abcxyz',
//         resave: false,
//         saveUninitialized: true,
//         cookie: {
//             secure: true,
//             sameSite: 'none',
//             domain: '.bank-database-production.up.railway.app',
//             maxAge: 30 * 24 * 60 * 60 * 1000,
//         },
//     })
// );

routes(app);

app.listen(port, () => {
    console.log('Server is running on port ' + port);
});
