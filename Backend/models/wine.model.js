const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const wineSchema = new Schema({
  _id: {
    type: String,
    required: true,
    unique: true,
  },
  nom: String,
  descriptif: String,
  embouteillage: String,
  cepage: String,
  chateau: String,
  prix: Number,
},
{ versionKey: false });

module.exports = mongoose.model('Wine', wineSchema, 'wines');
