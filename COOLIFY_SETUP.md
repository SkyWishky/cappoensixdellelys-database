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
4. Renseignez comme source le dépôt GitHub : `https://github.com/SkyWishky/cappoensixdellelys-database` (branche `main`).
5. Indiquez le chemin vers le fichier Compose : `docker-compose.coolify.yml` (la configuration dédiée à Coolify).

### Étape 2 : Configurer les domaines et variables d'environnement
Dans la configuration du service **front** :
- **Domains** : `https://tpfinal.tp-devops-6.online`
- **Port interne** : `8080` (image Nginx non-root).
- Coolify génère et renouvelle automatiquement le certificat SSL via Let's Encrypt.

Variables d'environnement dans l'onglet **Environment Variables** de Coolify :
```env
POSTGRES_DB=tamagochi
POSTGRES_USER=tamagochi
POSTGRES_PASSWORD=<secret-à-définir-dans-Coolify>

DB_HOST=database
DB_PORT=5432
DB_NAME=tamagochi
DB_USER=tamagochi
DB_PASSWORD=<même-secret-que-POSTGRES_PASSWORD>
SERVER_PORT=8080
PET_DECAY_INTERVAL=10000

BACKEND_URL=http://backend:8080
PORT=8080
```

### Étape 3 : Configurer les Webhooks de Déploiement Continu
Pour la ressource **Docker Compose (stack)** dans Coolify :
1. Rendez-vous dans ses paramètres > **Webhooks** et copiez son URL **Deploy Webhook**.
2. Ajoutez la même URL comme secret `COOLIFY_DEPLOY_WEBHOOK_URL` dans chacun des trois dépôts GitHub (front, back et database), sous **Settings > Secrets and variables > Actions**. Les trois workflows déploient cette stack unique; les anciens noms `COOLIFY_BACK_DEPLOY_WEBHOOK_URL` et `COOLIFY_DB_DEPLOY_WEBHOOK_URL` ne sont pas lus.
3. Les pushes sur `main` et `develop` publient les images correspondantes sous GHCR : `main` alimente `latest`, `develop` alimente `dev-latest`. Seuls les pushes `main` déclenchent le déploiement de production; le Compose Coolify utilise explicitement `latest` et `pull_policy: always` pour récupérer les images publiées.
4. Sans `COOLIFY_DEPLOY_WEBHOOK_URL`, l'étape de déploiement échoue explicitement au lieu de signaler un déploiement réussi. Un webhook configuré est appelé en GET et toute réponse HTTP en erreur fait échouer l'étape.

> **Registre d'images :** les images sont tirées de GHCR. Vérifiez qu'elles sont publiques ou configurez dans Coolify un registre GHCR authentifié disposant d'un droit de lecture des packages.

---

## 🔍 Vérification du Déploiement en Production

1. Accédez à l'URL : [https://tpfinal.tp-devops-6.online](https://tpfinal.tp-devops-6.online)
2. Vérifiez que la page d'accueil Angular se charge avec le certificat HTTPS valide.
3. Les animaux virtuels doivent s'afficher avec leurs statistiques (récupérées via `/api/pets` relayé au backend).
4. Cliquez sur **Feed** ou **Play** pour tester les requêtes POST d'interaction.
