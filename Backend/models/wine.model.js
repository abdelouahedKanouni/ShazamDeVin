const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const commentaireSchema = new Schema({
  createdBy: {
      type: String,
      ref: 'User',
      required: true,
  },
  commentaire: String,
  note: Number,
});

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
  commentaires: [commentaireSchema],
},
{ versionKey: false });

module.exports = mongoose.model('Wine', wineSchema, 'wines');
