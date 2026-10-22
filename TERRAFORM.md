# Guide Terraform

Ce dossier contient la configuration pour deployer localement la stack avec Terraform et le provider Docker.

## Prerequis

- Docker installe et demarre.
- Terraform installe (version 1.5 ou superieure).

## Fichiers

- `main.tf` : Definition du reseau Docker, du volume persistant PostgreSQL et des 3 conteneurs (base de donnees, backend et frontend).
- `variables.tf` : Variables de configuration (ports, versions des images, identifiants).
- `outputs.tf` : URLs d'acces generees apres le deploiement.
- `terraform.tfvars.example` : Exemple de fichier de variables.

## Commandes pour deployer

Les fichiers `main.tf`, `variables.tf` et `outputs.tf` configurent le réseau Docker, le volume PostgreSQL et les trois conteneurs. L'image PostgreSQL personnalisée publiée sur GHCR contient déjà `seed.sql`; aucun montage du fichier de l'hôte n'est nécessaire.

### 1. Fournir le secret

Le mot de passe est obligatoire et sensible. Ne l'ajoutez pas à un fichier suivi par Git. Depuis la racine du dépôt, définissez-le dans l'environnement :

```bash
# Bash
export TF_VAR_db_password='<mot-de-passe-local>'

# PowerShell
$env:TF_VAR_db_password = '<mot-de-passe-local>'
```

Les valeurs non secrètes peuvent être copiées depuis `terraform/terraform.tfvars.example`.

### 2. Initialiser, valider et planifier

```bash
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan
```

### 3. Appliquer ou détruire

```bash
terraform apply
# Pour supprimer les conteneurs, le volume et le réseau :
terraform destroy
```

Les ports par défaut PostgreSQL `5432`, API `8080` et frontend `4200` sont liés à `127.0.0.1`. `pet_decay_interval` vaut `10000` millisecondes.

Les sorties incluent `frontend_url`, `backend_api_url`, `backend_health_url`, `database_endpoint` et `database_name`. Le mot de passe n'est pas affiché, mais le provider Docker stocke les variables du conteneur dans l'état Terraform : protégez cet état et ne le partagez pas.
