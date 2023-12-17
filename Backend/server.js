const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');
const crypto = require('crypto');
const session = require('express-session');
const cookieParser = require('cookie-parser');

const port = "8080";
const db_connection = "mongodb://127.0.0.1:27017/shazamDeVinBdd";
const ip_address = "192.168.1.27"; // Mettre l'adresse ip du pc sur lequel se situe le serveur

mongoose.connect(db_connection, {
});

const app = express();
app.use(cookieParser());
app.use(bodyParser.json());
app.use(cors());

app.use(session({
  secret: crypto.randomBytes(32).toString('hex'),
  resave: false,
  saveUninitialized: true,
  cookie: { maxAge: 24 * 60 * 60 * 1000 }, // Durée de vie d'une journée en millisecondes
}));

const authRoutes = require('./routes/authRoutes');
const wineRoutes = require('./routes/wineRoutes');

app.use('/auth', authRoutes);
app.use('/wine', (req, res, next) => {
console.log(req.session);
    if (!req.session.user) {
        return res.status(401).json({ message: 'Erreur, vous devez être authentifié pour accéder à ces ressources' });
    }
    next();
}, wineRoutes);

app.listen(port, ip_address, () => {
  console.log(`Server is running on port ${port}`);
});
