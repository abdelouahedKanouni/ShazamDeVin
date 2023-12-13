const bcrypt = require('bcrypt');
const User = require('../models/user.model');

exports.login = async (req, res) => {
  try {
    const user = await User.findOne({ identifiant: req.body.identifiant });

    if (!user) {
      res.status(401).json({ message: 'Pas encore inscrit ? Inscrivez-vous !' });
    } else {
      const passwordMatch = await bcrypt.compare(req.body.password, user.password);

      if (passwordMatch) {
        req.session.user = user;
        req.session.save();
        console.log(req.session);
        console.log(req.session.id);
        res.json(user);
      } else {
        res.status(402).json({ message: 'Les informations de connexion sont incorrectes' });
      }
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Internal server error' });
  }
};

exports.signup = async (req, res) => {
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
};

exports.logout = (req, res) => {
    res.status(200).json({ message: 'Logged out' });
}
