# 📋 Guide de Déploiement - Coffee Meetings Platform sur Render

## 🎯 Objectif
Ce guide vous accompagne pas à pas pour déployer votre backend Django sur Render.com

---

## 📋 Prérequis

### 1. Comptes nécessaires
- [ ] Compte GitHub
- [ ] Compte Render (https://render.com)
- [ ] Repository GitHub avec votre projet

### 2. Outils installés
- [ ] Git
- [ ] Python 3.8+
- [ ] PostgreSQL (local pour tests)

---

## 🚀 Étape 1 : Préparation du projet

### 1.1 Vérifier la configuration
```bash
# Vérifier que DEBUG=False dans settings.py
# Vérifier que ALLOWED_HOSTS est configuré
```

### 1.2 Créer le fichier `render.yaml`
```bash
touch render.yaml
```

### 1.3 Ajouter le fichier `render.yaml`
```yaml
databases:
  - name: coffee-meetings-db
    databaseName: coffee_meetings
    user: coffee_user
    plan: starter

services:
  - type: web
    name: coffee-meetings-backend
    env: python
    buildCommand: "./build.sh"
    startCommand: "gunicorn coffee_meetings_platform.wsgi:application"
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: coffee-meetings-db
          property: connectionString
      - key: SECRET_KEY
        generateValue: true
      - key: WEB_CONCURRENCY
        value: 4
      - key: PYTHON_VERSION
        value: 3.9.0
```

---

## 🛠️ Étape 2 : Scripts de build et démarrage

### 2.1 Créer le script de build
```bash
touch build.sh
```

### 2.2 Contenu de `build.sh`
```bash
#!/usr/bin/env bash
# exit on error
set -o errexit

pip install -r requirements.txt

python manage.py collectstatic --no-input
python manage.py migrate
```

### 2.3 Rendre le script exécutable
```bash
chmod +x build.sh
```

---

## 🔧 Étape 3 : Configuration des variables d'environnement

### 3.1 Variables requises
Créez un fichier `.env` local pour tester :
```bash
# .env (ne pas pousser sur GitHub)
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=your-app.onrender.com,localhost,127.0.0.1
DATABASE_URL=postgresql://user:password@localhost:5432/coffee_meetings
REDIS_URL=redis://localhost:6379/1
JWT_SECRET_KEY=your-jwt-secret-key
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
FRONTEND_URL=https://your-frontend-url.com
```

### 3.2 Variables Render
Dans le dashboard Render, ajoutez ces variables :
- `SECRET_KEY` : Générer une clé secrète forte
- `ALLOWED_HOSTS` : Votre domaine Render + localhost pour tests
- `DATABASE_URL` : Fourni automatiquement par Render
- `REDIS_URL` : URL Redis (optionnel)
- `JWT_SECRET_KEY` : Clé secrète pour JWT
- `EMAIL_*` : Configuration email
- `FRONTEND_URL` : URL de votre frontend

---

## 📊 Étape 4 : Configuration PostgreSQL

### 4.1 Créer la base de données sur Render
1. Dans le dashboard Render
2. Créer une nouvelle database PostgreSQL
3. Noter le nom et les identifiants

### 4.2 Migration initiale
```bash
# Local pour tester
python manage.py makemigrations
python manage.py migrate
```

---

## 🚀 Étape 5 : Déploiement sur Render

### 5.1 Connecter GitHub à Render
1. Aller sur https://dashboard.render.com
2. Cliquer sur "New" → "Web Service"
3. Connecter votre compte GitHub
4. Sélectionner votre repository

### 5.2 Configuration du service
- **Name**: coffee-meetings-backend
- **Environment**: Python
- **Build Command**: `./build.sh`
- **Start Command**: `gunicorn coffee_meetings_platform.wsgi:application`
- **Instance Type**: Free (pour commencer)

### 5.3 Ajouter la database
1. Dans le dashboard Render
2. Créer une nouvelle database PostgreSQL
3. Attacher la database au service web

---

## 🔍 Étape 6 : Vérification post-déploiement

### 6.1 Vérifier les logs
```bash
# Dans le dashboard Render
# Vérifier les logs de build et de démarrage
```

### 6.2 Tester l'API
```bash
# Test de base
curl https://your-app.onrender.com/api/status/

# Test avec authentification
curl -H "Authorization: Bearer YOUR_TOKEN" https://your-app.onrender.com/api/campaigns/
```

### 6.3 Vérifier la base de données
```bash
# Se connecter à la DB Render
# Vérifier que les migrations ont été appliquées
```

---

## 🛡️ Étape 7 : Sécurité et optimisation

### 7.1 HTTPS obligatoire
- Toutes les communications doivent être en HTTPS
- Configurer les CORS pour votre frontend

### 7.2 CORS Configuration
```python
# Dans settings.py pour production
CORS_ALLOWED_ORIGINS = [
    "https://your-frontend-domain.com",
    "https://www.your-frontend-domain.com",
]
```

### 7.3 Sécurité des cookies
```python
# Pour production
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
```

---

## 🔄 Étape 8 : Mises à jour futures

### 8.1 Déploiement automatique
- Chaque push sur la branche principale déclenche un nouveau déploiement
- Les migrations sont appliquées automatiquement

### 8.2 Monitoring
- Utiliser les logs Render
- Configurer des alertes si nécessaire

---

## 📞 Support et dépannage

### Problèmes courants

#### ❌ Build échoue
```bash
# Vérifier les dépendances
pip install -r requirements.txt --dry-run
```

#### ❌ Database connection error
```bash
# Vérifier DATABASE_URL
# Vérifier que la DB est bien créée
```

#### ❌ Static files non servis
```bash
# Vérifier STATIC_ROOT et STATIC_URL
python manage.py collectstatic --dry-run
```

### Commandes utiles
```bash
# Logs Render
render logs coffee-meetings-backend

# Redéployer
render deploys create coffee-meetings-backend
```

---

## ✅ Checklist finale

- [ ] DEBUG=False dans settings.py
- [ ] ALLOWED_HOSTS configuré
- [ ] Variables d'environnement définies
- [ ] Database PostgreSQL créée
- [ ] Scripts build.sh et start.sh créés
- [ ] Fichier render.yaml créé
- [ ] Repository GitHub poussé
- [ ] Service Render créé
- [ ] Tests de l'API réussis
- [ ] HTTPS configuré

---

## 🎉 Félicitations !
Votre backend Django est maintenant déployé sur Render et prêt à recevoir des requêtes !
