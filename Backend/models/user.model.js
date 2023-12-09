const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const newSchema = new Schema({
  identifiant: String,
  password: String,
  is_admin: Boolean,
}, { versionKey: false });


module.exports = mongoose.model('User',newSchema,'users')
