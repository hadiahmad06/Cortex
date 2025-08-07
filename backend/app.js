// app.js
const express = require('express');
const cors = require('cors');
const promptRouter = require('./routes/prompt');

const app = express();
app.use(cors());
app.use(express.json());
app.use('/api/prompt', promptRouter);

module.exports = app;