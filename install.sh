#!/usr/bin/env bash
# ============================================
#  WoSB Marché - Client d'installation
#  Installe et lance le site + l'API
# ============================================

set -e

REPO_URL="https://github.com/EmpireDesPirates/wosb-marche.git"
DIR="wosb-marche"
PORT=3000

BLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}"
echo "============================================"
echo "      ⚓ WoSB Marché - Installation ⚓"
echo "============================================"
echo -e "${NC}"

# 1. Vérifier Node.js
echo -e "${BLUE}[*] Vérification de Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo "[!] Node.js n'est pas installé."
    echo "    Installe-le depuis https://nodejs.org (version 16+)"
    echo "    Ou avec ton gestionnaire de paquets :"
    echo "      sudo apt install nodejs npm   (Debian/Ubuntu)"
    echo "      brew install node             (macOS)"
    exit 1
fi
echo -e "${GREEN}[✓] Node.js $(node -v) détecté${NC}"

# 2. Récupérer le dépôt
if [ -d "$DIR" ]; then
    echo -e "${BLUE}[*] Dossier existant détecté, mise à jour...${NC}"
    cd "$DIR"
    git pull
else
    echo -e "${BLUE}[*] Téléchargement du projet...${NC}"
    git clone "$REPO_URL"
    cd "$DIR"
fi

# 3. Installer les dépendances
echo -e "${BLUE}[*] Installation des dépendances (express, cors)...${NC}"
if [ ! -f api/package.json ]; then
    cd api
    npm init -y > /dev/null
    cd ..
fi
cd api
npm install express cors --silent
cd ..

# 4. Lancer le serveur
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN} ✓ Installation terminée !${NC}"
echo -e "${GREEN} Démarrage du serveur sur le port ${PORT}...${NC}"
echo -e "${GREEN} Ouvre http://localhost:${PORT}${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

cd api
node server.js
