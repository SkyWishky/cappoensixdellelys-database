# Gitflow du projet

Ce projet utilise une organisation en branches Gitflow :

- `main` : Branche de production, correspond a la version stable deployee sur Coolify.
- `develop` : Branche de developpement principal et d'integration.
- `feature/*` : Branches temporaires pour developper de nouvelles fonctionnalites avant fusion sur `develop`.
- `hotfix/*` : Branches pour corriger un bug critique directement depuis `main`.

## 📌 Architecture des Branches

```text
  main ──────●────────────────────────● (v1.0.0 / Production)
             ▲                        ▲
             │                        │ Merge release
  release ───┼──────────●─────────────┘
             │          ▲
             │          │ Cut release
  develop ───●──●───────●──●──────────► (Intégration continue)
                ▲       ▲  ▲
     feature ───┘       │  │
                        └──┘
```

### 1. Branches Principales (Long-lived)

| Branche | Rôle | Environnement de déploiement | Protection |
|---|---|---|---|
| **`main`** | Code stable de production | Coolify Production (webhook CI) | À configurer/vérifier dans GitHub |
| **`develop`** | Intégration continue; publie `dev-latest` | Aucun déploiement Coolify automatique configuré | À configurer/vérifier dans GitHub |

### 2. Branches Temporaires (Short-lived)

- **`feature/<nom-fonctionnalite>`** :
  - Créée depuis : `develop`
  - Mergée dans : `develop`
  - Exemple : `feature/terraform-hcl-formatting`, `feature/database-backup-cron`
- **`release/vX.Y.Z`** :
  - Créée depuis : `develop`
  - Mergée dans : `main` ET `develop`
- **`hotfix/<nom-correctif>`** :
  - Créée depuis : `main`
  - Mergée dans : `main` ET `develop`

---

## 🛡️ Règles de Validation CI/CD

Le pipeline GitHub Actions s'exécute sur les pushes/PR vers `develop` et `main`. Pour rendre ces contrôles obligatoires avant merge, les règles de protection doivent être configurées dans GitHub (état à vérifier auprès d'un administrateur) :
1. ✅ `terraform -chdir=terraform fmt -check` et `terraform -chdir=terraform validate`.
2. ✅ Hadolint sur le `Dockerfile` PostgreSQL.
3. ✅ Construction et publication de l'image Docker sur GHCR (`ghcr.io/skywishky/cappoensixdellelys-database`).
