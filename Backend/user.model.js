const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  identifiant: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  is_admin: { type: Boolean, default: false },
});

const User = mongoose.model('User', userSchema);

module.exports = User;
