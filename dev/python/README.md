# Python Workflow (Pipenv-Based)

This module documents the **standard Python development workflow** used across
projects in this dotfiles setup.

The goal is to make Python usage:

- safe by default
- reproducible
- framework-agnostic
- free of global package pollution

This applies equally to:
- Django
- FastAPI
- CLI tools
- small scripts

---

## Core Principles

1. **No global Python packages**
2. **Every project owns its environment**
3. **Dependencies are explicit**
4. **The shell should not manage Python state**

---

## Environment Management

Python environments are managed with **pipenv**.

Key rules:

- Virtual environments live **inside the project**
- No reliance on shell activation (`pipenv shell` is avoided)
- Commands are run explicitly in the project context

Environment variable enforced globally:

```sh
PIPENV_VENV_IN_PROJECT=1
````

This creates a `.venv/` directory in each project.

---

## Installing Dependencies

Instead of `pip install`, always use:

```sh
pipenv install <package>
```

Examples:

```sh
pipenv install django
pipenv install requests
pipenv install --dev pytest black
```

This updates:

* `Pipfile` (declared dependencies)
* `Pipfile.lock` (exact versions)

---

## Running Commands

### Preferred (no shell activation)

Use `pipenv run`:

```sh
pipenv run python script.py
pipenv run pytest
pipenv run django-admin startproject config .
```

This:

* activates the environment temporarily
* runs the command
* exits cleanly

No subshells, no state leaks.

---

### Via Project Helpers

Framework-specific helpers (e.g. `dj`) wrap `pipenv run` internally.

Example:

```sh
dj run
dj migrate
dj startapp blog
```

In this case, **you do not need to think about pipenv at all**.

---

## Listing Dependencies

### Declared dependencies (source of truth)

```sh
cat Pipfile
```

### Exact installed versions

```sh
pipenv graph
```

or inspect:

```sh
Pipfile.lock
```

### Environment snapshot (when needed)

```sh
pipenv run pip list
pipenv run pip freeze
```

---

## pip Safety Guard

To prevent accidental global installs, `pip` is guarded:

```sh
pip() {
  if [ -z "$VIRTUAL_ENV" ]; then
    echo "❌ pip blocked outside virtualenv"
    return 1
  fi
  command pip "$@"
}
```

This ensures:

* `pip` can only run inside a virtual environment
* system Python remains clean
* mistakes are caught early

---

## What You Do *Not* Do

* Do **not** uninstall system `pip`
* Do **not** rely on `pip freeze` as a project definition
* Do **not** use `pipenv shell` in zsh
* Do **not** install Python packages globally

---

## Typical Workflow

```text
cd project/
pipenv install <deps>
dj run        (or pipenv run …)
commit Pipfile + Pipfile.lock
```

No activation.
No deactivation.
No global state.

---

## Philosophy

Python tooling should be:

* explicit, not implicit
* project-scoped, not global
* boring and predictable

This workflow exists so Python setup is solved once
and never revisited.
