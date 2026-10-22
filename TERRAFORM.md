# 🏗️ Guide d'Utilisation de l'Infrastructure Terraform

Ce document détaille l'utilisation de l'Infrastructure as Code (IaC) **HashiCorp Terraform** pour provisionner et orchestrer localement la stack complète Tamagotchi via le provider Docker (`kreuzwerker/docker`).

---

## 📋 Prérequis

1. **Docker Engine** ou **Docker Desktop** en cours d'exécution.
2. **Terraform CLI** version 1.5.0 ou supérieure installée :
   ```bash
   terraform version
   ```

---

## 📁 Architecture des Fichiers Terraform

- `main.tf` :
  - Configuration du provider `kreuzwerker/docker` (version `~> 3.0.2`).
  - Déclaration du réseau Docker en mode bridge (`tamagotchi_net`).
  - Déclaration du volume persistant pour PostgreSQL (`pgdata_volume`).
  - Téléchargement des images Docker depuis GitHub Container Registry (GHCR).
  - Déclaration et ordonnancement des trois conteneurs (`cappoensixdellelys-db`, `cappoensixdellelys-back`, `cappoensixdellelys-front`).
- `variables.tf` : Variables paramétrables (noms des images, tags, ports exposés, identifiants de base de données).
- `outputs.tf` : Affichage formaté des points d'accès (URLs du frontend, de l'API et de la base de données).
- `terraform.tfvars.example` : Modèle de fichier de surcharge des valeurs par défaut.

---

## 🚀 Commandes Usuelles

### 1. Initialiser le répertoire de travail

Télécharge et installe le provider `kreuzwerker/docker` :
```bash
cd terraform
terraform init
```

### 2. Valider la syntaxe et la cohérence

```bash
terraform validate
terraform fmt -check
```

### 3. Prévisualiser les modifications (Plan)

```bash
terraform plan
```

### 4. Déployer l'infrastructure (Apply)

Provisionne le réseau, le volume et démarre les trois conteneurs :
```bash
terraform apply -auto-approve
```

À l'issue de l'exécution, Terraform affiche le récapitulatif des sorties :
```text
Outputs:

api_health_url = "http://localhost:8080/actuator/health"
database_connection_string = "postgresql://tamagochi:tamagochi_secret@localhost:5432/tamagochi"
frontend_url = "http://localhost:4200"
infrastructure_status = "Tamagotchi 3-tier stack successfully provisioned with Terraform"
```

### 5. Détruire l'infrastructure (Destroy)

Arrête et supprime les conteneurs, le volume et le réseau proprement :
```bash
terraform destroy -auto-approve
```
