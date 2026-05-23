# Git PR Workflows

---

# 1. Solo / Team Project (Direct Repo Access)

Used when you already have write access to the repository.

## Create branch

```bash
git checkout -b chore/curl-setup
```

## Push branch to upstream

```bash
git push upstream chore/curl-setup
```

## Create PR

```bash
gh pr create
```

Or:

```bash
gh pr create --fill
```

## Merge PR

After review:

```bash
gh pr merge
```

Or merge from GitHub UI.

---

# 2. Open Source Workflow (Fork + Upstream)

Used when contributing to repositories you do not own.

## Fork repository

Fork on GitHub first.

## Add upstream remote

```bash
git remote add upstream git@github.com:OWNER/REPO.git
```

## Create branch

```bash
git checkout -b feature/my-feature
```

## Push to your fork

```bash
git push origin feature/my-feature
```

---

## Create PR to upstream repo from fork

```bash
gh pr create --repo upstream-owner/repo-name
```

Or explicitly:

```bash
gh pr create \
    --base main \
    --head your-username:feature/my-feature \
    --fill
```

### Flags

- `--base` → target branch/repo
- `--head` → source branch from your fork
- `--fill` → auto-fill PR title/body from commit message

---

# 3. Sync Your Fork With Upstream

Before starting new work:

```bash
git fetch upstream

git checkout main

git merge upstream/main

git push origin main
```

---

# 4. Helpful Commands

## Check remotes

```bash
git remote -v
```

## Fetch latest changes

```bash
git fetch --all
```

## Delete local branch

```bash
git branch -d feature/my-feature
```

## Delete remote branch

```bash
git push origin --delete feature/my-feature
```
