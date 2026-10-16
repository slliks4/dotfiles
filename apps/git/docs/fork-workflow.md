# Fork Workflow (Simple Guide)

## Overview

- `origin` → your fork (your repo)
- `upstream` → original repo (team repo)

You:
- work on your fork
- create branches
- open PRs to upstream
- sync your fork after merge

---

## 1. Fork the repository

Using GitHub CLI:

```bash
gh repo fork <owner/repo> --clone
````

This:

* forks the repo to your account
* clones it locally
* sets `origin` → your fork

---

## 2. Add upstream (original repo)

```bash
git remote add upstream <original-repo-url>
```

Check:

```bash
git remote -v
```

You should see:

```
origin    https://github.com/you/repo.git
upstream  https://github.com/original/repo.git
```

---

## 3. Sync your fork with upstream

Before starting any work:

```bash
git fetch upstream
git checkout main   # or DJANGO (whatever default branch is)
git merge upstream/main
git push origin main
```

---

## 4. Create a new branch

Always branch from your main branch:

```bash
git checkout -b feature/my-feature
```

---

## 5. Work and commit

```bash
git add .
git commit -m "Add my feature"
```

---

## 6. Push to your fork

```bash
git push origin feature/my-feature
```

---

## 7. Create Pull Request (PR)

On GitHub:

* Base repo → upstream
* Base branch → main (or whatever)
* Compare → your branch (`feature/my-feature`)

On cli:
gh pr create
or
gh pr create --base upstream:main --head your-username:feature/my-feature --fill
or
gh pr create --repo upstream-owner/repo-name --fill

--base upstream:main → PR goes to upstream repo
--head your-username:feature/... → from your fork
--fill → auto-uses commit message as PR title/body

---

## 8. After PR is merged

DO NOT merge manually into your fork.

Instead, sync again:

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## 9. Clean up branches

```bash
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```

---

## Key Rules

* Never work directly on `main`
* Always create a branch
* Always sync from `upstream`
* Never push directly to `upstream`
* PR → upstream, not your fork

---

## Quick Workflow

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main

git checkout -b feature/x
# work
git commit -am "feature"
git push origin feature/x
# create PR

# after merge
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```
