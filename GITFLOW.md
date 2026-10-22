# 🌿 Stratégie de Branches Gitflow - Database & Infrastructure

Ce dépôt respecte la méthodologie standard **Gitflow** pour assurer un cycle de livraison fiable, traçable et sécurisé.

---

## 📌 Architecture des Branches

```text
  main ──────●────────────────────────● (v1.0.0 / Production)
             ▲                        ▲
             │                        │ Merge release
  release ───┼──────────●─────────────┘
             │          ▲
             │          │ Cut release
  develop ───●──●───────●──●──────────► (Intégration continue / Staging)
                ▲       ▲  ▲
     feature ───┘       │  │
                        └──┘
```

### 1. Branches Principales (Long-lived)

| Branche | Rôle | Environnement de déploiement | Protection |
|---|---|---|---|
| **`main`** | Code stable de production | Coolify Production | Protégée (PR requise, checks CI validés) |
| **`develop`** | Intégration continue | Coolify Staging | Protégée (Merge via PR uniquement) |

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

Avant tout merge sur `develop` ou `main`, le pipeline GitHub Actions valide obligatoirement :
1. ✅ `terraform fmt -check` et `terraform validate`.
2. ✅ Hadolint sur le `Dockerfile` PostgreSQL.
3. ✅ Construction et publication de l'image Docker sur GHCR (`ghcr.io/skywishky/cappoensixdellelys-database`).
