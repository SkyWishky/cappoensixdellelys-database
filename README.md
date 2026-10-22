# 🗄️ Database & Infrastructure - PostgreSQL, Docker Compose & Terraform

[![CI/CD Pipeline](https://github.com/SkyWishky/cappoensixdellelys-database/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/SkyWishky/cappoensixdellelys-database/actions/workflows/ci-cd.yml)
[![Docker Image](https://img.shields.io/badge/Docker-GHCR-blue?logo=docker)](https://github.com/SkyWishky/cappoensixdellelys-database/pkgs/container/cappoensixdellelys-database)
[![Terraform](https://img.shields.io/badge/Terraform-1.16+-623CE4?logo=terraform)](https://www.terraform.io)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql)](https://www.postgresql.org)
[![Branching](https://img.shields.io/badge/Git-Gitflow-orange?logo=git)](GITFLOW.md)

Ce dépôt centralise l'infrastructure, la persistance des données et l'orchestration du projet **Tamagotchi** :
1. **Base de données PostgreSQL 16 Alpine** avec injection automatique du schéma et des données de seed (`seed.sql`).
2. **Orchestration locale complète Docker Compose** (`docker-compose.yml`) avec réseau pont dédié, variables d'environnement centralisées et volumes persistants.
3. **Infrastructure as Code (IaC) Terraform** (`terraform/`) pilotant le cycle de vie des conteneurs, réseaux et volumes Docker via le provider `kreuzwerker/docker`.
4. **Guides de déploiement Coolify & Gitflow** pour la mise en production sur `https://tpfinal.tp-devops-6.online`.

Projet réalisé dans le cadre du **TP Noté DevOps AP4 (2026)** - **Groupe 6 : Cappoen / Six / Dellelys**.

---

## 🏗️ Architecture Globale du Projet

```text
                                       INTERNET
                                           │
                                           ▼ (HTTPS : Let's Encrypt SSL)
                           ┌───────────────────────────────┐
                           │   Coolify / Traefik Ingress   │
                           │  tpfinal.tp-devops-6.online   │
                           └───────────────┬───────────────┘
                                           │ (Port 80)
                                           ▼
                           ┌───────────────────────────────┐
                           │      cappoensixdellelys-      │
                           │       front (Angular 22)      │
                           │     Nginx Reverse Proxy       │
                           └───────────────┬───────────────┘
                                           │ (/api/*)
                                           ▼ (Port 8080)
                           ┌───────────────────────────────┐
                           │      cappoensixdellelys-      │
                           │     back (Spring Boot 21)     │
                           └───────────────┬───────────────┘
                                           │ (Port 5432)
                                           ▼
                           ┌───────────────────────────────┐
                           │      cappoensixdellelys-      │
                           │     database (PostgreSQL)     │
                           │      Volume: pgdata_vol       │
                           └───────────────────────────────┘
```

---

## 📁 Structure du Dépôt

```text
cappoensixdellelys-database/
├── .github/
│   └── workflows/
│       └── ci-cd.yml           # Pipeline CI/CD : Terraform validate, Hadolint, GHCR build/push
├── terraform/
│   ├── main.tf                 # Définition des conteneurs, réseau et volume Docker
│   ├── variables.tf            # Variables d'entrée typées avec descriptions et défauts
│   ├── outputs.tf              # URLs et endpoint de la base
│   └── terraform.tfvars.example # Exemple sans secret
├── Dockerfile                  # Image custom PostgreSQL 16 Alpine pré-chargée avec seed.sql
├── docker-compose.yml          # Orchestration multi-conteneurs pour test local immédiat
├── seed.sql                    # Initialisation de la table pet et jeu de données de test
├── .dockerignore
├── .gitignore
├── COOLIFY_SETUP.md            # Guide pas-à-pas de configuration et déploiement sur Coolify
├── TERRAFORM.md                # Guide d'utilisation de l'infrastructure Terraform
├── GITFLOW.md                  # Méthodologie et stratégie des branches
└── README.md
```

---

## 🚀 Démarrage Rapide en Local

### Option A : Avec Docker Compose (Recommandé pour tester en 1 commande)

```bash
# Copier .env.example vers .env puis remplacer POSTGRES_PASSWORD par un secret local.
cp .env.example .env

# Lancement de l'ensemble de la stack (Frontend, Backend, Database)
docker compose up -d

# Vérification du statut des conteneurs
docker compose ps

# Consultation des logs applicatifs
docker compose logs -f

# Arrêt de la stack
docker compose down
```

L'application est disponible uniquement sur la machine locale à [http://localhost:4200](http://localhost:4200). L'API reste interne au réseau Compose et est accessible via le proxy frontend.

---

### Option B : Avec Terraform (Infrastructure as Code)

Consultez le guide complet : **[TERRAFORM.md](TERRAFORM.md)**.

```bash
cd terraform

# Initialisation du provider Docker
terraform init

# Validation syntaxique et sémantique
terraform validate

# Planification des ressources à provisionner
# Fournir le secret sans l'inscrire dans un fichier versionné :
# export TF_VAR_db_password='<mot-de-passe-local>'
terraform plan

# Application et démarrage des conteneurs
terraform apply -auto-approve

# Destruction propre des ressources
terraform destroy -auto-approve
```

Avec Terraform, les ports frontend `4200`, API `8080` et PostgreSQL `5432` sont liés à `127.0.0.1`. Avec Compose, seul le frontend est publié sur `127.0.0.1:4200`; l'API et PostgreSQL restent internes au réseau. Le mot de passe PostgreSQL est requis via `TF_VAR_db_password`; protégez l'état Terraform, qui peut contenir les variables de conteneur.

---

## 🌐 Déploiement en Production sur Coolify

Consultez le guide pas-à-pas : **[COOLIFY_SETUP.md](COOLIFY_SETUP.md)**.

- **URL de l'interface Coolify** : [https://coolify.twelveparsecs.me/](https://coolify.twelveparsecs.me/)
- **Nom de domaine attribué (Groupe 6)** : `tp-devops-6.online`
- **URL finale de production** : [https://tpfinal.tp-devops-6.online](https://tpfinal.tp-devops-6.online)

---

## 🌿 Stratégie Gitflow

Consultez le document dédié : **[GITFLOW.md](GITFLOW.md)**.

- **`main`** : Branche de production validée.
- **`develop`** : Branche d'intégration continue.
- **`feature/*`**, **`release/*`**, **`hotfix/*`** : Cycle standard Gitflow.

---

## 📦 Dépôts du Projet

- 🌐 **Frontend** : [https://github.com/SkyWishky/cappoensixdellelys-front](https://github.com/SkyWishky/cappoensixdellelys-front)
- ☕ **Backend** : [https://github.com/SkyWishky/cappoensixdellelys-back](https://github.com/SkyWishky/cappoensixdellelys-back)
- 🗄️ **Database & Infra** : [https://github.com/SkyWishky/cappoensixdellelys-database](https://github.com/SkyWishky/cappoensixdellelys-database)
- 🌍 **Déploiement Production Coolify** : [https://tpfinal.tp-devops-6.online](https://tpfinal.tp-devops-6.online)
