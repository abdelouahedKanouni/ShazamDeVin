const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());

// Autoriser toutes les origines pour le moment (pour le développement)
app.use(cors());

mongoose.connect('mongodb://127.0.0.1:27017/shazamDeVinBdd', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const User = mongoose.model('User', {
  identifiant: String,
  password: String,
  is_admine: Boolean,
});

const port = 8080;

// Modifier la ligne ci-dessous pour écouter sur toutes les interfaces
app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
});

app.post('/login', async (req, res) => {

    console.log(req.body);
  const { identifiant, password } = req.body;
  const user = await User.findOne({ identifiant });

  if (!user || !(await bcrypt.compare(password, user.password))) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  //const token = jwt.sign({ userId: user.id, email: user.email }, 'votre_secret_key');
  //res.json({ token });
});
