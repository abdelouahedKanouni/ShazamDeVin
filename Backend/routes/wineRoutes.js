const express = require('express');
const wineController = require('../controllers/wineController');
const router = express.Router();

router.post('/verify', wineController.verifyWine);

router.post('/saveDetails', wineController.saveWineDetails);

router.post('/loadDetails', wineController.loadWineDetails);

router.get('/loads', wineController.loadWines);

router.post('/delete', wineController.deleteWine);

module.exports = router;
