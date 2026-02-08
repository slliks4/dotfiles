# pyenv — Python Version Management

This directory installs and configures **pyenv** for managing
multiple Python versions locally.

The setup follows the same principles as the rest of the dev environment:

- explicit installation
- no global Python modification
- shell-based activation
- reproducible on a fresh system

---

## 📦 What This Sets Up

- `pyenv` installed in:

```text
~/.pyenv
````

* Shell integration via `.zshrc`
* No system Python is replaced
* No Python versions are installed automatically

---

## ⚙️ Installation

From the dotfiles root:

```sh
cd dev/pyenv
./install.sh
```

After installation:

```sh
source ~/.zshrc
```

---

## 🐍 Installing Python Versions

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

## 🧠 Configuration Model

Shell integration is added to:

```text
~/.zshrc
```

The install script appends the configuration **only if missing**,
so it is safe to run multiple times.

---

## 📌 Notes

* Works with `pip`, `venv`, and `pipenv`
* Recommended for development only
* System Python remains untouched
