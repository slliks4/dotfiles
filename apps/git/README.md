# Git

Installs a minimal, portable Git configuration.

This module:
- checks for Git and optionally GitHub CLI (`gh`)
- installs the tracked `.gitconfig` into `$HOME`
- backs up existing configurations before replacing them
- skips installation if the configuration is already up to date

---

## Installation

Ensure Git is installed, then run:

```bash
./install.sh
```

The installer does not install packages automatically.

---

## Dependencies

- `git` (required)
- `gh` (optional, for GitHub authentication)
- `nvim` (optional, for `nvimdiff`)

---

## Configuration

The included `.gitconfig` provides:

- `main` as the default branch
- GitHub credential integration through `gh`
- `nvimdiff` as the diff tool
- support for a machine-specific `~/.gitconfig.local`

### Git Identity

Configure your name and email separately:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

The local configuration is not tracked by this repository.

### GitHub Authentication

If using GitHub CLI, authenticate with:

```bash
gh auth login
```

---

## Notes

- Existing `.gitconfig` files are backed up before replacement.
- Identical configurations are left unchanged.
- Configuration files are copied, not symlinked.
- Rerun `./install.sh` to apply changes from the repository.
- The installer does not modify existing Git repositories.

---

## Documentation

Additional Git commands, workflows, and reference notes are available in `docs/`.
