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
