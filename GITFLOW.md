# Gitflow du projet

Ce projet utilise une organisation en branches Gitflow :

- `main` : Branche de production, correspond a la version stable deployee sur Coolify.
- `develop` : Branche de developpement principal et d'integration.
- `feature/*` : Branches temporaires pour developper de nouvelles fonctionnalites avant fusion sur `develop`.
- `hotfix/*` : Branches pour corriger un bug critique directement depuis `main`.

Les modifications sont testees et validees automatiquement par GitHub Actions avant d'etre deployees.
