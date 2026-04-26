# Git Basics

This document contains commonly used commands and workflows.

---

## Repository Setup

Initialize a repository:

```bash
git init
````

Clone a repository:

```bash
git clone <url>
```

---

## Basic Workflow

Check status:

```bash
git status
```

Stage changes:

```bash
git add <file>
git add .
```

Commit changes:

```bash
git commit -m "message"
```

Push to remote:

```bash
git push
```

Pull latest changes:

```bash
git pull
```

---

## Branching

Create a branch:

```bash
git branch <name>
```

Switch branch:

```bash
git checkout <name>
```

Create and switch:

```bash
git checkout -b <name>
```

---

## Diff and Inspection

View changes:

```bash
git diff
```

---

## Using difftool (nvim)

Requires Neovim.

Set diff tool:

```bash
git config --global diff.tool nvimdiff
git config --global difftool.prompt false
```

Run:

```bash
git difftool
```

---

## Vimdiff Navigation

Inside diff view:

```
]c  next change
[c  previous change
do  obtain change
dp  put change
:q  quit
```

---

## LazyGit (Optional)

Install:

```bash
sudo pacman -S lazygit
```

Run:

```bash
lazygit
```

Provides a terminal UI for Git operations.

---

## Notes

* Keep commits small and focused
* Write clear commit messages
* Pull before pushing to avoid conflicts
