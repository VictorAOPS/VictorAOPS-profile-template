# Repo Structure (Current State)

This document describes the current repository structure and conventions.

## Production Surface

- `README.md` (root) is the GitHub Profile README.
- Any local path referenced from `README.md` must exist and be tracked.

## Top-Level Layout

- `.github/`
  - `workflows/icons-carousel.yml`
  - `workflows/markdownlint.yml`
  - `workflows/link-check.yml`
  - `ISSUE_TEMPLATE/` intake forms
- `docs/`
  - `readme/` reusable README building blocks
  - `archive/` legacy and experiments
- `images/`
  - canonical assets used by `README.md`
- `scripts/`
  - asset generation scripts
- `STACK_ICONS.md`
  - source rows for skill-icons carousel generation

## Images (Canonical Paths)

- Hero:
  - `images/hero/github-banner-1600x450@2x.gif`
  - `images/hero/github-banner-1600x450@1x.gif`
- Carousel:
  - `images/icons/icons-carousel.gif`
- Placeholders:
  - `images/placeholders/latest-articles-featured.svg`
- Diagrams:
  - `images/diagrams/sequence-redux-dark.svg`
  - `images/diagrams/source/sequence-diagram.mmd`
- Dividers:
  - `images/dividers/divider.gif`
- Legacy/History:
  - `images/archive/`
- Local drafts (ignored):
  - `images/drafts/`

## Docs Structure

- `docs/readme/layout-rules.md`
- `docs/readme/components.md`
- `docs/readme/text-styles.md`
- `docs/readme/fonts.md`
- `docs/readme/activity/models.md`
- `docs/readme/activity/neon-style.md`

## Automation Contracts

- `scripts/gen_icons_carousel.py` default output:
  - `images/icons/icons-carousel.gif`
- `.github/workflows/icons-carousel.yml` reads:
  - `STACK_ICONS.md`
  - `scripts/gen_icons_carousel.py`
  and updates:
  - `images/icons/icons-carousel.gif`

## Ignore Policy (Key Rules)

- `.venv/` is ignored and must remain untracked.
- Local drafts are ignored:
  - `images/drafts/`
  - `assets/drafts/`
- Typical temp/cache ignores:
  - `__pycache__/`, `.DS_Store`, `*.log`, `*.tmp`

## Quick Integrity Checks

Before push:

1. Verify README image paths exist:
   - `rg -o 'images/[^)\" ]+' README.md | sort -u`
2. Verify carousel target consistency:
   - `rg -n "images/icons/icons-carousel.gif" scripts .github/workflows`
3. Keep root `README.md` unchanged in location (profile requirement).
