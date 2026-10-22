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

```bash
cd terraform

# Initialiser le provider Docker
terraform init

# Verifier la syntaxe
terraform validate

# Lancer les conteneurs
terraform apply
```

## Pour arreter

```bash
terraform destroy
```
