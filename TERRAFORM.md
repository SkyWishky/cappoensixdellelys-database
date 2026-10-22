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
  - Déclaration du réseau Docker en mode bridge et du volume persistant PostgreSQL.
  - Téléchargement des images Docker (base personnalisée avec le seed, backend, frontend) depuis GHCR.
  - Déclaration des trois conteneurs avec vérifications de santé PostgreSQL et API.
- `variables.tf` : Images, ports, identifiants et intervalle de decay (en millisecondes).
- `outputs.tf` : URL frontend/API, URL de santé backend, endpoint et nom de la base.
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

### 3. Configurer le secret et prévisualiser (Plan)

Le mot de passe est obligatoire et sensible. Ne l'ajoutez pas à un fichier suivi par Git. Pour un usage local, fournissez-le dans l'environnement courant (ou utilisez un gestionnaire de secrets) :
```bash
# Bash
export TF_VAR_db_password='<mot-de-passe-local>'
# PowerShell
$env:TF_VAR_db_password = '<mot-de-passe-local>'
```
Les valeurs non secrètes peuvent être copiées depuis l'exemple : `cp terraform.tfvars.example terraform.tfvars` (depuis le dossier `terraform`).
Les ports Terraform par défaut sont `5432` (PostgreSQL), `8080` (API) et `4200` (frontend), tous liés à `127.0.0.1`. Avec Docker Compose, seul le frontend est publié sur l'hôte; l'API et PostgreSQL restent internes. `pet_decay_interval` vaut `10000` millisecondes. La base utilise l'image personnalisée publiée sur GHCR, qui contient le script d'initialisation; aucune bind-mount du fichier `seed.sql` de l'hôte n'est nécessaire.

```bash
terraform plan
```

### 4. Déployer l'infrastructure (Apply)

Provisionne le réseau, le volume et démarre les trois conteneurs :
```bash
terraform apply -auto-approve
```

À l'issue de l'exécution, Terraform affiche les sorties suivantes (valeurs par défaut) :
```text
Outputs:

backend_api_url = "http://localhost:8080"
backend_health_url = "http://localhost:8080/actuator/health"
database_endpoint = "localhost:5432"
database_name = "tamagochi"
frontend_url = "http://localhost:4200"
```
L'output ne contient jamais le mot de passe. Le provider Docker enregistre toutefois les variables d'environnement du conteneur dans l'état Terraform : protégez cet état local et ne le partagez pas.

### 5. Détruire l'infrastructure (Destroy)

Arrête et supprime les conteneurs, le volume et le réseau proprement :
```bash
terraform destroy -auto-approve
```
