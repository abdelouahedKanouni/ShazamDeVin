const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');

// process.env to access environment variables
const port = "8080";
const db_connection = "mongodb://127.0.0.1:27017/shazamDeVinBdd";
const ip_address = "192.168.1.27"; // Mettre l'adresse ip du pc sur lequel se situe le serveur

// Connect to the MongoDB database
mongoose.connect(db_connection, {
});

// Create Express app
const app = express();
app.use(bodyParser.json());
app.use(cors());

// Import routes
const authRoutes = require('./routes/authRoutes');
const wineRoutes = require('./routes/wineRoutes');

// Use routes
app.use('/auth', authRoutes);
app.use('/wine', wineRoutes);

// Start the server
app.listen(port, ip_address, () => {
  console.log(`Server is running on port ${port}`);
});
