# Utiliser une image de base Node.js
FROM node:20

# Définir le répertoire de travail
WORKDIR /app

# Installer les outils nécessaires pour le téléchargement, la décompression, et Git
RUN apt-get update && apt-get install -y \
    curl \
    p7zip-full \
    git \
    net-tools \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Télécharger l'archive .7z contenant le code de l'API
RUN curl -L -o BusinessSimulatorAPI_test.7z \
    https://github.com/Ben290402/BFF-POC/raw/2c74bc27b1e950b0ed66020022c172e3eba06af2/BusinessSimulatorAPI_test.7z && \
    ls -l BusinessSimulatorAPI_test.7z || (echo "Erreur: fichier .7z non trouvé" && exit 1)

# Décompresser l'archive .7z dans le répertoire de travail et vérifier le contenu
RUN 7z x BusinessSimulatorAPI_test.7z -o/app && \
    ls -l /app/BusinessSimulatorAPI && \
    test -f /app/BusinessSimulatorAPI/package.json || (echo "Erreur: package.json non trouvé après décompression" && exit 1)

# Installer les dépendances Node.js
RUN cd /app/BusinessSimulatorAPI && npm install

# Exposer le port sur lequel l'API écoute (port 3001 d'après le script)
EXPOSE 3001

# Démarrer l'API
CMD ["node", "/app/BusinessSimulatorAPI/businessSimulator.js"]
