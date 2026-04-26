# pyenv — Python Version Management

This module installs and configures **pyenv** for managing
multiple Python versions locally.

The setup follows the same principles as the rest of the dev environment:

- explicit installation
- no global Python modification
- shell-based activation via `conf.d`
- reproducible on a fresh system

---

## What This Sets Up

- `pyenv` installed in:

```text
~/.pyenv
````

* Shell integration via:

```text
~/.config/zsh/conf.d/pyenv.zsh
```

* No system Python is replaced
* No Python versions are installed automatically

---

## Installation

From the dotfiles root:

```sh
cd dev/pyenv
./install.sh
```

Restart your shell to activate pyenv.

---

## Shell Integration

pyenv is loaded through your modular shell system:

```text
~/.config/zsh/conf.d/pyenv.zsh
```

Make sure your `.zshrc` sources `conf.d`:

```sh
for file in ~/.config/zsh/conf.d/*.zsh; do
  [ -f "$file" ] && source "$file"
done
```

---

## Installing Python Versions

List available versions:

```sh
pyenv install --list
```

Install a version:

```sh
pyenv install 3.12.2
```

Set global Python:

```sh
pyenv global 3.12.2
```

Set per-project Python:

```sh
pyenv local 3.11.8
```

---

## Configuration Model

Shell configuration is managed through:

```text
~/.config/zsh/conf.d/pyenv.zsh
```

The install script:

* creates the configuration if missing
* does not modify `.zshrc`
* is safe to run multiple times

---

## Notes

* Works with `pip`, `venv`, and `pipenv`
* System Python remains untouched
* Python versions are installed per-user via pyenv

---

## Philosophy

Python tooling should be:

* isolated from the system
* reproducible per project
* free of global conflicts

This module ensures Python development remains clean and predictable.
