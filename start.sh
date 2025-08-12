#!/usr/bin/env bash
# Script de démarrage pour Render.com avec Procfile
# Ce script est optionnel car Render utilise directement le Procfile

# Activer le mode erreur
set -o errexit

echo "🚀 Démarrage de Coffee Meetings Platform avec Procfile..."

# Vérifier les variables d'environnement
echo "🔍 Vérification des variables d'environnement..."
if [ -z "$SECRET_KEY" ]; then
    echo "❌ ERREUR: SECRET_KEY n'est pas définie"
    exit 1
fi

if [ -z "$DATABASE_URL" ]; then
    echo "❌ ERREUR: DATABASE_URL n'est pas définie"
    exit 1
fi

# Afficher les informations de configuration
echo "📊 Configuration:"
echo "DEBUG: $DEBUG"
echo "ALLOWED_HOSTS: $ALLOWED_HOSTS"
echo "PORT: $PORT"

# Message de démarrage
echo "🎯 Démarrage de l'application via Procfile..."
echo "Commande: gunicorn coffee_meetings_platform.wsgi:application --bind 0.0.0.0:$PORT --workers 3 --timeout 120"

# Le démarrage réel est géré par le Procfile via Render
echo "✅ Configuration prête pour Render avec Procfile!"
