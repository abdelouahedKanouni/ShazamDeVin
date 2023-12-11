const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const bodyParser = require('body-parser');
const cors = require('cors');
const User = require('./models/user.model');
const Wine = require('./models/wine.model');

const app = express();
app.use(bodyParser.json());

// Autoriser toutes les origines pour le moment (pour le développement)
app.use(cors());

mongoose.connect('mongodb://127.0.0.1:27017/shazamDeVinBdd', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const port = 8080;

// Modifier la ligne ci-dessous pour écouter sur toutes les interfaces
app.listen(port, '192.168.1.27', () => { // Mettre l'adresse ip du pc sur lequel se situe le serveur
  console.log(`Server is running on port ${port}`);
});

app.post('/login', async (req, res) => {
  try {
    const user = await User.findOne({ identifiant: req.body.identifiant });

    if (!user) {
      res.status(401).json({ message: 'Pas encore inscrit ? Inscrivez-vous !' });
    } else {
      const passwordMatch = await bcrypt.compare(req.body.password, user.password);

      if (passwordMatch) {
        res.json(user);
      } else {
        res.status(402).json({ message: 'Les informations de connexion sont incorrectes' });
      }
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

app.post('/logout', (req, res) => {
    res.status(200).json({ message: 'Déconnexion réussie' });

});

app.post('/signup', async (req, res) => {
  try {
    const { identifiant, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({ identifiant, password: hashedPassword, is_admin: false });
    await newUser.save();
    res.status(200).json({ message: 'Utilisateur créé avec succès' });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

app.post('/verifyWine', async (req, res) => {
  try {
    const wineId = req.body.barcode;

    const existingBarcode = await Wine.findOne({ _id: wineId });

    if (existingBarcode) {
      res.json({ message: 'Code-barres déjà existant : '  + req.body.barcode});
    } else {
      const newWine = new Wine({ _id : wineId });
      await newWine.save();
      res.json({ message: 'Code-barres créé avec succès : ' + req.body.barcode});
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

app.post('/saveWineDetails', async (req, res) => {
  try {
    const existingWine = await Wine.findOne({ _id: req.body.id });

    if (existingWine) {
      await Wine.updateOne({ _id: req.body.id }, req.body);

      res.status(200).json({ message: 'Détails du vin mis à jour avec succès' });
    } else {
      const newWine = new Wine(req.body);
      await newWine.save();

      res.status(200).json({ message: 'Détails du vin enregistrés avec succès' });
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Erreur lors de la mise à jour/enregistrement des détails du vin' });
  }
});

app.post('/loadWineDetails', async (req, res) => {
  try {
    const wineId = req.body.barcode;
    const existingWine = await Wine.findOne({ _id: wineId });

    if (existingWine) {
      res.json({
        nom: existingWine.nom,
        descriptif: existingWine.descriptif,
        embouteillage: existingWine.embouteillage,
        cepage: existingWine.cepage,
        chateau: existingWine.chateau,
        prix: existingWine.prix,
      });
    } else {
      res.status(404).json({ message: 'Aucun détail trouvé pour le code-barres donné' });
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Internal server error' });
  }
});
