# Contributing

## How to propose changes
- Use the issue forms in `.github/ISSUE_TEMPLATE`.
- Keep `README.md` at repository root (GitHub profile requirement).
- Prefer small PRs with clear scope.

## Pull Request Rules
- Update paths/references when files are moved.
- Preserve history using `git mv` for renames/moves.
- Do not commit local environments (`.venv/`) or drafts assets.
- Ensure `README.md` renders without broken image links.

## Release / Versioning
- For major README upgrades, bump `PROFILE_LP__vX.Y.Z` in `README.md`.
- Record the same change in `CHANGELOG.md` with date and short impact summary.
- Keep the `README.md` `Updates` section synchronized with `CHANGELOG.md`.
- Keep only the latest changes visible in `README.md` `Updates`:
  - Recommended: last 5 entries
  - Maximum: last 10 entries
- Optional: create a Git tag (`vX.Y.Z`) when you want a visible release milestone.

## PR Definition of Done (DoD)
- `README.md` render is OK on GitHub preview.
- Required workflows are green.
- No new orphan assets are introduced.
- Critical links are reachable.
- Section anchors and navigation links work correctly.

## Labels used by intake and CRO links
Create these labels in the GitHub repository UI:
- `source/readme`
- `intent/inbound`
- `intent/collab`
- `intent/hub`
- `request/project`
- `domain/supply-chain`
- `domain/maintenance`
- `domain/production`
- `qualified`
- `in_progress`
- `waiting`
- `outcome/won-project`
- `outcome/won-collab`
- `outcome/won-interview`
- `outcome/closed-no-fit`
- `outcome/closed-no-response`
- `outcome/closed-later`

Recommended convention:
- `source/*` for acquisition channel
- `intent/*` for inbound intent
- `request/*` for request type
- `domain/*` for business domain
- `outcome/*` for closed result tracking
