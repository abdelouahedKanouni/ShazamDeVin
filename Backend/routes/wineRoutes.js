const express = require('express');
const wineController = require('../controllers/wineController');
const router = express.Router();

// Route for verifying wine barcode
router.post('/verify', wineController.verifyWine);

// Route for saving/updating wine details
router.post('/saveDetails', wineController.saveWineDetails);

// Route for loading wine details
router.post('/loadDetails', wineController.loadWineDetails);

// Route for loading wines
router.get('/loads', wineController.loadWines);

module.exports = router;
