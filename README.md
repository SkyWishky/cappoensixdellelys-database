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

Pour lancer l'application en local (build la base avec son seed et telecharge le frontend et le backend depuis le registre) :

```bash
docker compose up -d
```

Pour arreter les conteneurs :
```bash
docker compose down
```

## Utilisation de Terraform

Un guide simple est disponible dans `TERRAFORM.md`.
Pour lancer avec Terraform :
```bash
cd terraform
terraform init
terraform apply
```

## Pipeline CI/CD (GitHub Actions)

A chaque push sur `main` et `develop`, le pipeline execute :
1. Verification du format et validation des fichiers Terraform (`terraform fmt` et `terraform validate`).
2. Verification du Dockerfile avec Hadolint.
3. Construction et publication de l'image PostgreSQL sur GitHub Container Registry (ghcr.io).
4. Declenchement du webhook de deploiement automatique sur Coolify.

## Liens des depots du projet

- Frontend : https://github.com/SkyWishky/cappoensixdellelys-front
- Backend : https://github.com/SkyWishky/cappoensixdellelys-back
- Database et Infra : https://github.com/SkyWishky/cappoensixdellelys-database
