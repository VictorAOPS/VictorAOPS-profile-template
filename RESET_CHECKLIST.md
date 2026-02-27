# Repo Reset Checklist (No History + CC BY 4.0)

Use this checklist to recreate `VictorOPEX/VictorOPEX` with zero prior GitHub-visible history.

## 1) Preflight (must pass)

- [ ] Confirm local backup exists:
  - [ ] `backup/repo-no-history/`
  - [ ] `backup/project-export/`
  - [ ] `backup/VictorOPEX-backup-no-history-*.tar.gz`
- [ ] Confirm repo snapshot includes:
  - [ ] `.github/workflows/`
  - [ ] `.github/ISSUE_TEMPLATE/`
  - [ ] `docs/inbound/`
  - [ ] `README.md`
- [ ] Confirm current working tree is clean or intentionally parked.

## 2) Delete and recreate the GitHub repository

- [ ] In GitHub: `VictorOPEX/VictorOPEX` -> `Settings` -> `General` -> `Danger Zone` -> `Delete this repository`
- [ ] Recreate new empty repo with same name:
  - [ ] Owner: `VictorOPEX`
  - [ ] Name: `VictorOPEX`
  - [ ] Public
  - [ ] Do not initialize with README/LICENSE/.gitignore

## 3) Re-import without old history

Run:

```bash
cd /mnt/d/GitHub
rm -rf VictorOPEX-clean
cp -r VictorOPEX/backup/repo-no-history VictorOPEX-clean
cd VictorOPEX-clean
rm -rf .git

git init
git branch -M main
git add -A
git commit -m "Initial clean import (no prior history)"
git remote add origin https://github.com/VictorOPEX/VictorOPEX.git
git push -u origin main
```

Validation:
- [ ] GitHub repo shows exactly 1 commit on `main`
- [ ] No old PR/issues/commit history visible in this repo

## 4) Apply CC BY 4.0 license

Create/replace `LICENSE` with:

```text
Creative Commons Attribution 4.0 International

This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
```

Run:

```bash
git add LICENSE
git commit -m "docs: add CC BY 4.0 license"
git push
```

Validation:
- [ ] `LICENSE` exists at root
- [ ] `README.md` references CC BY 4.0 (and no MIT reference remains)

## 5) Restore operational config (GitHub-side)

### Secrets
- [ ] Add `ADD_TO_PROJECT_PAT` in:
  - `Repo -> Settings -> Secrets and variables -> Actions`
- [ ] PAT contains required scopes (`repo`, `project`)

### Labels
- [ ] Recreate required labels from `backup/project-export/labels.txt`
- [ ] Verify label families exist:
  - [ ] `source/*`
  - [ ] `intent/*`
  - [ ] `request/*`
  - [ ] `domain/*`
  - [ ] `outcome/*`
  - [ ] `qualified`, `in_progress`, `waiting`

### Project link
- [ ] Link repo to Project v2:

```bash
gh project link 3 --owner VictorOPEX --repo VictorOPEX/VictorOPEX
```

- [ ] Verify `Pipeline` field exists with:
  - [ ] `New`
  - [ ] `Qualified`
  - [ ] `In Progress`
  - [ ] `Waiting`
  - [ ] `Closed/Won`

## 6) Automation validation

- [ ] Workflow files present:
  - [ ] `.github/workflows/inbound-auto-add-to-project.yml`
  - [ ] `.github/workflows/inbound-pipeline-sync.yml`
  - [ ] `.github/workflows/asset-integrity.yml`
  - [ ] `.github/workflows/markdownlint.yml`
  - [ ] `.github/workflows/link-check.yml`
- [ ] Create test issue with label `intent/inbound`
- [ ] Confirm issue auto-added to Project
- [ ] Add label `qualified`, confirm Pipeline -> `Qualified`
- [ ] Add label `in_progress`, confirm Pipeline -> `In Progress`
- [ ] Add label `waiting`, confirm Pipeline -> `Waiting`
- [ ] Add label `outcome/won-project` or close issue, confirm Pipeline -> `Closed/Won`

## 7) Post-reset hardening

- [ ] Set branch protections/rulesets on `main`
- [ ] Require checks:
  - [ ] `markdownlint`
  - [ ] `link-check`
  - [ ] `asset-integrity`
- [ ] Disable force-push to `main` (after migration is complete)

## 8) Security note (important)

- [ ] If any secret was ever exposed in prior history, rotate it now.
- [ ] Reissue PAT used by Actions if there is any doubt.

## 9) Rollback plan

If import fails:
- [ ] Keep new repo as-is (do not force random fixes).
- [ ] Re-import from `backup/repo-no-history/`.
- [ ] Use `backup/project-export/*.json` to restore board/labels consistency.

