# Scripts

## Regenerate icons carousel

This repository generates `images/icons/icons-carousel.gif` from `STACK_ICONS.md`.

### Local setup
```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install cairosvg pillow
```

### Generate
```bash
python scripts/gen_icons_carousel.py
```

### Output
- `images/icons/icons-carousel.gif`

## Full backup (no history) + project metadata

Creates a complete local backup suitable for clean repo recreation:
- `backup/repo-no-history/` (all files except `.git`, `.venv`, `backup/`)
- `backup/project-export/` (project fields/items + labels/workflows/secrets list)
- `backup/VictorOPEX-backup-no-history-<timestamp>.tar.gz`

Run:
```bash
bash scripts/create_clean_backup.sh
```

Optional environment variables:
```bash
OWNER=VictorOPEX REPO=VictorOPEX/VictorOPEX PROJECT_NUMBER=3 bash scripts/create_clean_backup.sh
```

## Prepare clean restore (single commit, no old history)

Builds a fresh folder from `backup/repo-no-history/`, initializes git, and creates one initial commit.

Run:
```bash
bash scripts/prepare_clean_restore.sh /mnt/d/GitHub/VictorOPEX-clean
```

Then push to a newly created empty repo:
```bash
cd /mnt/d/GitHub/VictorOPEX-clean
git remote add origin https://github.com/VictorOPEX/VictorOPEX.git
git push -u origin main
```
