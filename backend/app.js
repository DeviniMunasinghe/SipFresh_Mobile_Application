const express = require('express');
const morgan = require('morgan');

const app = express();

// Middleware
app.use(morgan('dev')); 
app.use(express.json());


app.get('/', (req, res) => {
    res.send('Server is running!');
});

const authRoutes = require("./api/routes/auth-routes");
const itemRoutes = require("./api/routes/item-routes");

app.use("/api/auth", authRoutes);
app.use("/api/items", itemRoutes);

module.exports = app; 