# WoSB Marché

Site web de marché pour **World of Sea Battle (WoSB)**, connecté à une API qui reçoit/envoie les données du jeu.

## Structure

```
/
├── index.html          # Page du marché
├── css/style.css       # Style
├── js/app.js           # Logique frontend (appelle l'API)
└── api/
    ├── server.js       # API REST (Node.js + Express)
    └── data.json       # Données du jeu (joueurs, navires, objets)
```

## API

- `GET  /api/game-data` — données complètes du jeu
- `GET  /api/market` — liste des offres du marché
- `POST /api/market` — publier une offre
- `POST /api/game-data` — le jeu envoie ses données ici

### Exemple (le jeu envoie des données)

```bash
curl -X POST http://localhost:3000/api/game-data \
  -H "Content-Type: application/json" \
  -d '{"players": 42, "ships": 120, "event": "Guerre des Flottes"}'
```

## Lancer

```bash
cd api
npm install express cors
node server.js
```

Le site est servi sur http://localhost:3000
