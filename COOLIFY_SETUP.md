# Configuration Coolify

Ce document resume la configuration du deploiement sur Coolify.

## Informations du deploiement

- Serveur Coolify : https://coolify.twelveparsecs.me
- Domaine du frontend : https://tpfinal.tp-devops-6.online
- Type de ressource : Docker Compose (Empty Service)

## Services deployes

1. `frontend` : Application Angular + Nginx sur le port 80 avec le domaine public configure.
2. `backend` : API Spring Boot Java 21 reliee a la base de donnees et accessible en interne via le frontend.
3. `database` : PostgreSQL 16 avec volume persistant pour stocker les donnees.

## Deploiement continu (CD)

Le deploiement est automatise via le webhook Coolify dans GitHub Actions. Chaque push sur `main` ou `develop` declenche automatiquement la mise a jour de la stack en production sur Coolify.
