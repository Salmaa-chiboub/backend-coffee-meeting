#!/usr/bin/env bash
# Script de build pour Render.com avec Procfile
# Ce script est exécuté automatiquement par Render lors du déploiement

# Activer le mode erreur pour arrêter le script en cas d'erreur
set -o errexit

echo "🚀 Démarrage du build pour Coffee Meetings Platform..."

# Afficher les informations système
echo "📊 Informations système:"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"

# Installer les dépendances Python
echo "📦 Installation des dépendances..."
pip install -r requirements.txt

# Vérifier que Django est installé
echo "✅ Vérification de Django..."
python -c "import django; print(f'Django version: {django.VERSION}')"

# Collecter les fichiers statiques
echo "📁 Collecte des fichiers statiques..."
python manage.py collectstatic --no-input --clear

# Appliquer les migrations de la base de données
echo "🔄 Application des migrations..."
python manage.py migrate --no-input

# Vérifier la connexion à la base de données
echo "🔍 Vérification de la connexion à la base de données..."
python manage.py check --database default

# Afficher les informations de fin de build
echo "✅ Build terminé avec succès!"
echo "🎯 Application prête pour le démarrage via Procfile..."
