@echo off
REM ============================================================
REM   WoSB Marche - Client d'installation pour Windows
REM   Usage : double-cliquez sur install.bat
REM   (ou ouvrez un invite de commandes et executez : install.bat)
REM ============================================================

title WoSB Marche - Installation
color 0B
echo.
echo  ============================================
echo     WoSB MARCHE - Installation (Windows)
echo  ============================================
echo.

REM --- 1. Verifier Node.js ---
echo [1/4] Verification de Node.js...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo  [ERREUR] Node.js n'est pas installe sur ce PC.
    echo  Telechargez-le ici : https://nodejs.org  ^(version LTS^)
    echo  puis relancez install.bat.
    echo.
    pause
    exit /b 1
)
for /f "delims=" %%v in ('node --version') do set NODEV=%%v
echo        OK - Node.js %NODEV% detecte.
echo.

REM --- 2. Recuperer le projet ---
echo [2/4] Recuperation du projet...
if exist "wosb-marche" (
    echo        Dossier existant trouve - mise a jour...
    cd wosb-marche
    git pull >nul 2>nul
) else (
    where git >nul 2>nul
    if %errorlevel% neq 0 (
        echo  [INFO] Git n'est pas installe - telechargement ZIP...
        powershell -Command "Invoke-WebRequest -Uri 'https://github.com/EmpireDesPirates/wosb-marche/archive/refs/heads/main.zip' -OutFile 'wosb-marche.zip'"
        powershell -Command "Expand-Archive -Path 'wosb-marche.zip' -DestinationPath '.' -Force"
        del wosb-marche.zip
        cd wosb-marche-main
    ) else (
        git clone https://github.com/EmpireDesPirates/wosb-marche.git
        cd wosb-marche
    )
)
echo        OK - Projet pret.
echo.

REM --- 3. Installer les dependances ---
echo [3/4] Installation des dependances...
cd api
call npm install
if %errorlevel% neq 0 (
    echo.
    echo  [ERREUR] Echec de l'installation des dependances.
    echo  Verifiez votre connexion internet et relancez install.bat.
    echo.
    pause
    exit /b 1
)
echo        OK - Dependances installees.
echo.

REM --- 4. Demarrer le serveur ---
echo [4/4] Demarrage du serveur...
echo.
echo  ============================================
echo     Installation terminee !
echo     Ouvrez votre navigateur sur :
echo         http://localhost:3000
echo     (la page s'ouvre automatiquement)
echo     Appuyez sur Ctrl+C pour arreter le serveur.
echo  ============================================
echo.
start "" http://localhost:3000
node server.js
pause
