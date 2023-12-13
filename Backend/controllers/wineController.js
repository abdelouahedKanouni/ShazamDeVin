const Wine = require('../models/wine.model');

// Controller function for verifying wine barcode
exports.verifyWine = async (req, res) => {
  try {
    const wineId = req.body.barcode;
    const existingBarcode = await Wine.findOne({ _id: wineId });
    if (existingBarcode) {
      res.json({ message: 'Vin déjà existant : ' + req.body.barcode });
    } else {
      res.status(404).json({ message: 'Le vin n\'existe pas : ' + req.body.barcode });
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Internal server error' });
  }
};

// Controller function for saving/updating wine details
exports.saveWineDetails = async (req, res) => {
  try {
    /* if (!req.session.user.is_admin) {
      res.status(401).json({ message: 'Erreur, vous devez être authentifiez et administrateur pour cette action' });
    } */
    const existingWine = await Wine.findOne({ _id: req.body.id });

    if (existingWine) {
      await Wine.updateOne({ _id: req.body.id }, req.body);
      res.status(200).json({ message: 'Détails du vin mis à jour avec succès' });
    } else {
      const newWine = new Wine({ ...req.body, _id: req.body.id });
      await newWine.save();
      res.status(200).json({ message: 'Détails du vin enregistrés avec succès' });
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Erreur lors de la mise à jour/enregistrement des détails du vin' });
  }
};

// Controller function for loading wine details
exports.loadWineDetails = async (req, res) => {
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
};

// Controller function for loading wines
exports.loadWines = async (req, res) => {
  try {
    let query = {};
    // Sorting
    const sortField = req.query.sortField || 'nom'; // Default sorting by name
    const sortOrder = req.query.sortOrder === 'desc' ? -1 : 1;
    const sort = { [sortField]: sortOrder };
    
    // Searching by name
    const searchTerm = req.query.searchTerm;
    if (searchTerm) {
      query.nom = { $regex: new RegExp(searchTerm, 'i') }; // Case-insensitive search
    }

    const wines = await Wine.find(query).sort(sort);
    res.status(200).json(wines);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.deleteWine = async (req, res) => {
  const { barcode } = req.body.barcode;

  try {
    /* if (!req.session.user.is_admin) {
      res.status(401).json({ message: 'Erreur, vous devez être authentifiez et administrateur pour cette action' });
    } */
    const deletedWine = await Wine.findOneAndDelete({ id: barcode });

    if (deletedWine) {
      res.status(200).json({ message: 'Suppression réussie' });
    } else {
      res.status(404).json({ message: 'Aucun vin trouvé avec ce code-barres' });
    }
  } catch (error) {
    console.error('Erreur lors de la suppression du vin :', error);
    res.status(500).json({ message: 'Erreur lors de la suppression du vin' });
  }
};
