# Database et Infrastructure - TP Note DevOps

Projet realise dans le cadre du TP Note DevOps AP4 2026.
Groupe 6 : Six Theo, Delelys Florian, Cappoen Louis.

Ce depot contient la configuration de la base de donnees PostgreSQL, l'infrastructure Terraform et les fichiers Docker Compose.

URL en production : https://tpfinal.tp-devops-6.online

## Architecture

- Base de donnees : PostgreSQL 16 Alpine
- Initialisation : Le fichier `seed.sql` est charge automatiquement au premier demarrage dans `/docker-entrypoint-initdb.d/01-seed.sql` pour creer la table et les donnees initiales.
- Infrastructure as Code : Dossier `terraform/` permettant de provisionner la stack Docker (reseau, volume et conteneurs).

## Lancer en local avec Docker Compose

Copiez `.env.example` vers `.env`, remplacez `POSTGRES_PASSWORD` par un secret local, puis lancez la stack :

```bash
cp .env.example .env
docker compose up -d
```

L'application est disponible uniquement sur la machine locale à [http://localhost:4200](http://localhost:4200). L'API et PostgreSQL restent internes au réseau Compose; l'API est accessible via le proxy frontend. Pour arrêter les conteneurs sans supprimer les données :

```bash
docker compose down
```

### Fonctionnement des conteneurs de la stack Compose

Le fichier `docker-compose.yml` orchestre trois conteneurs relies par un reseau prive et un volume persistant :

1. Service `database` (PostgreSQL 16 Alpine) :
- Role : Stockage relationnel de l'etat des animaux virtuels.
- Persistance : Les donnees sont ecrites dans le volume nomme `db_data` monte sur `/var/lib/postgresql/data`. Les donnees restent conservees meme lors de l'arret des conteneurs.
- Initialisation : Le script `seed.sql` est monte dans `/docker-entrypoint-initdb.d/01-seed.sql` et s'execute automatiquement au premier lancement pour creer les tables et injecter les animaux de depart.
- Sonde de disponibilite : Commande `pg_isready` toutes les 5 secondes pour certifier que PostgreSQL accepte les connexions avant que le backend ne tente de s'y connecter.

2. Service `backend` (Spring Boot 21 / Java 21) :
- Role : API REST fournissant la logique metier et la simulation d'evolution temporelle des animaux.
- Connexion : Rejoint la base directement via le nom d'hote `database` sur le port 5432 du reseau Docker interne.
- Ordonnancement : La directive `depends_on` avec `condition: service_healthy` empeche Spring Boot de demarrer tant que PostgreSQL n'a pas valide sa propre sonde de sante.
- Sonde de disponibilite : Interroge `/actuator/health` toutes les 10 secondes pour confirmer le statut operationnel du service.

3. Service `frontend` (Angular 22 / Nginx Alpine) :
- Role : Interface utilisateur web pour interagir avec les animaux (nourrir, jouer, consulter l'etat).
- Reverse proxy : Nginx sert les fichiers compiles Angular et relaie les requetes `/api/*` vers `http://backend:8080`. L'URL cible est injectee dynamiquement au demarrage via la variable `BACKEND_URL` sans recompiler le code.
- Ordonnancement : Attend que le backend soit declare en bonne sante avant d'ouvrir le service web.
- Exposition : Publie sur le port local 4200 (ou 80 selon le compose utilise).

4. Reseau et Volume partages :
- Reseau `tamagochi-network` : Reseau virtuel bridge isole. Il permet aux conteneurs de resoudre leurs noms mutuels par DNS interne (`database`, `backend`, `frontend`) sans exposer les ports sensibles directement sur la machine hote.
- Volume `db_data` : Stockage persistant independant du cycle de vie des conteneurs.

## Utiliser Terraform

Consultez le guide complet [TERRAFORM.md](TERRAFORM.md). Le mot de passe doit être fourni hors des fichiers versionnés :

```bash
export TF_VAR_db_password='<mot-de-passe-local>'
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Terraform lie les ports frontend `4200`, API `8080` et PostgreSQL `5432` à `127.0.0.1`; Compose ne publie que le frontend sur `127.0.0.1:4200`. L'état Terraform peut contenir des variables sensibles : protégez-le et ne le partagez pas. Pour supprimer l'infrastructure, exécutez `terraform destroy`.

## CI/CD et Gitflow

Le workflow `.github/workflows/ci-cd.yml` valide Terraform, contrôle le Dockerfile avec Hadolint, scanne les dépendances avec Trivy et publie l'image sur GHCR. `main` publie `latest` et déclenche le webhook Coolify; `develop` publie `dev-latest` sans déployer la production. Consultez [GITFLOW.md](GITFLOW.md) pour la stratégie de branches.

## Dépôts du projet

- Frontend : https://github.com/SkyWishky/cappoensixdellelys-front
- Backend : https://github.com/SkyWishky/cappoensixdellelys-back
- Base de données et infrastructure : https://github.com/SkyWishky/cappoensixdellelys-database
