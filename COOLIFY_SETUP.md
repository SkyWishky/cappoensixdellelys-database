# ☁️ Guide de Déploiement sur Coolify (PaaS)

Ce document décrit la procédure pas-à-pas pour déployer l'architecture 3-tiers sur l'instance **Coolify** de la promotion :
- **Instance Coolify** : [https://coolify.twelveparsecs.me/](https://coolify.twelveparsecs.me/)
- **Groupe 6** : `tp-devops-6.online`
- **URL Frontend en production** : [https://tpfinal.tp-devops-6.online](https://tpfinal.tp-devops-6.online)

---

## 🛠️ Méthode 1 : Déploiement via Docker Compose (Recommandée)

Cette méthode déploie l'ensemble de la stack en une seule ressource unifiée sur Coolify, simplifiant la résolution DNS interne entre conteneurs.

### Étape 1 : Créer une ressource Docker Compose sur Coolify
1. Connectez-vous sur [https://coolify.twelveparsecs.me/](https://coolify.twelveparsecs.me/).
2. Accédez à votre projet / environnement (ex: `Groupe 6`).
3. Cliquez sur **+ New Resource** > **Docker Compose**.
4. Renseignez comme source le dépôt GitHub privé : `https://github.com/SkyWishky/cappoensixdellelys-database` (branche `main`).
5. Indiquez le chemin vers le fichier Compose : `docker-compose.yml`.

### Étape 2 : Configurer les domaines et variables d'environnement
Dans la configuration du service **front** :
- **Domains** : `https://tpfinal.tp-devops-6.online`
- Coolify génère et renouvelle automatiquement le certificat SSL via Let's Encrypt.

Variables d'environnement dans l'onglet **Environment Variables** de Coolify :
```env
POSTGRES_DB=tamagochi
POSTGRES_USER=tamagochi
POSTGRES_PASSWORD=tamagochi_secret

DB_HOST=database
DB_PORT=5432
DB_NAME=tamagochi
DB_USER=tamagochi
DB_PASSWORD=tamagochi_secret
SERVER_PORT=8080
PET_DECAY_INTERVAL=10000

BACKEND_URL=http://back:8080
PORT=80
```

### Étape 3 : Configurer les Webhooks de Déploiement Continu
Pour chaque service dans Coolify :
1. Rendez-vous dans les paramètres du service > **Webhooks**.
2. Copiez l'URL de **Deploy Webhook** générée par Coolify.
3. Ajoutez ce secret dans les dépôts GitHub correspondants sous **Settings > Secrets and variables > Actions** :
   - Pour le frontend : `COOLIFY_DEPLOY_WEBHOOK_URL`
   - Pour le backend : `COOLIFY_BACK_DEPLOY_WEBHOOK_URL`
   - Pour la base de données : `COOLIFY_DB_DEPLOY_WEBHOOK_URL`
4. À chaque commit poussé sur `main` ou `develop`, GitHub Actions compile, publie l'image GHCR et déclenche le redéploiement automatique sur Coolify.

---

## 🔍 Vérification du Déploiement en Production

1. Accédez à l'URL : [https://tpfinal.tp-devops-6.online](https://tpfinal.tp-devops-6.online)
2. Vérifiez que la page d'accueil Angular se charge avec le certificat HTTPS valide.
3. Les animaux virtuels doivent s'afficher avec leurs statistiques (récupérées via `/api/pets` relayé au backend).
4. Cliquez sur **Feed** ou **Play** pour tester les requêtes POST d'interaction.
