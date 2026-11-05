// WoSB Marché — connexion à l'API du jeu
const API_URL = window.location.origin.startsWith('http')
  ? window.location.origin + '/api'
  : 'http://localhost:3000/api';

async function loadGameData() {
  const status = document.getElementById('status');
  try {
    const res = await fetch(`${API_URL}/game-data`);
    if (!res.ok) throw new Error('API indisponible');
    const data = await res.json();

    document.getElementById('stat-players').textContent = data.players ?? '–';
    document.getElementById('stat-ships').textContent = data.ships ?? '–';

    status.textContent = '✅ Connecté à l\'API WoSB';
    status.className = 'ok';
  } catch (e) {
    status.textContent = '❌ API WoSB hors ligne';
    status.className = 'err';
  }
}

async function loadMarket() {
  const body = document.getElementById('offers-body');
  try {
    const res = await fetch(`${API_URL}/market`);
    const offers = await res.json();
    document.getElementById('stat-offers').textContent = offers.length;

    body.innerHTML = offers.length
      ? offers.map(o => `
          <tr>
            <td>${o.item}</td>
            <td>${o.seller}</td>
            <td>${o.price} 🪙</td>
            <td>${new Date(o.date).toLocaleDateString('fr-FR')}</td>
          </tr>`).join('')
      : '<tr><td colspan="4">Aucune offre pour le moment.</td></tr>';
  } catch (e) {
    body.innerHTML = '<tr><td colspan="4">Impossible de charger le marché.</td></tr>';
  }
}

loadGameData();
loadMarket();
setInterval(() => { loadGameData(); loadMarket(); }, 30000); // rafraîchit toutes les 30 s
