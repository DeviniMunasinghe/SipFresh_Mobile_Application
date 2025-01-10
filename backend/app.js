const express = require('express');
const morgan = require('morgan');

const app = express();

// Middleware
app.use(morgan('dev')); 
app.use(express.json());


app.get('/', (req, res) => {
    res.send('Server is running!');
});

module.exports = app; 