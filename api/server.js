// API WoSB Marché — reçoit et sert les données de World of Sea Battle
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '..')));

const DATA_FILE = path.join(__dirname, 'data.json');

function readData() {
  return JSON.parse(fs.readFileSync(DATA_FILE, 'utf-8'));
}

function writeData(data) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
}

// Données complètes du jeu
app.get('/api/game-data', (req, res) => {
  res.json(readData().game);
});

// Le jeu envoie ses données ici (endpoint pour World of Sea Battle)
app.post('/api/game-data', (req, res) => {
  const data = readData();
  data.game = { ...data.game, ...req.body, lastUpdate: new Date().toISOString() };
  writeData(data);
  res.json({ ok: true, message: 'Données du jeu mises à jour' });
});

// Offres du marché
app.get('/api/market', (req, res) => {
  res.json(readData().market);
});

// Publier une offre
app.post('/api/market', (req, res) => {
  const { item, seller, price } = req.body;
  if (!item || !seller || !price) {
    return res.status(400).json({ ok: false, error: 'item, seller et price requis' });
  }
  const data = readData();
  const offer = { id: Date.now(), item, seller, price, date: new Date().toISOString() };
  data.market.push(offer);
  writeData(data);
  res.status(201).json({ ok: true, offer });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`⚓ WoSB Marché API sur http://localhost:${PORT}`));
