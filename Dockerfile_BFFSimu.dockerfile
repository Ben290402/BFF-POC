# Utiliser une image de base Node.js
FROM node:20

# Définir le répertoire de travail
WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    p7zip-full

# Copier les fichiers package.json et package-lock.json dans le conteneur
# COPY package.json package-lock.json ./

#Téléchargement du fichier .zip
RUN curl -L -o BFFSimulatorAPI_test.7z \
https://github.com/Ben290402/BFF-POC/raw/2c74bc27b1e950b0ed66020022c172e3eba06af2/BFFSimulatorAPI_test.7z


RUN 7z x BFFSimulatorAPI_test.7z -o/app
# Installer les dépendances
RUN cd /app/BFFSimulatorAPI && npm install

# Copier le fichier de simulation d'API
# COPY backForFrontSimulator.js .

# Exposer le port sur lequel l'API écoute (3002 dans backForFrontSimulator.js)
EXPOSE 3002

# Démarrer l'API
CMD ["node", "/app/BFFSimulatorAPI/backForFrontSimulator.js"]
