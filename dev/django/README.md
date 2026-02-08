# Django Helper (dj)

This module provides a small helper script (`dj`) for working with
**Django projects using pipenv**.

It is a developer tool and lives under `dev/`, not the system layer.

---

## What This Tool Does

- Bootstraps a new Django project using **pipenv**
- Keeps the virtual environment **inside the project**
- Wraps common `manage.py` commands
- Reduces repetitive setup steps

---

## Installation

From the dotfiles root:

```sh
cd dev/django
./install.sh
````

This creates a symlink:

```text
~/.local/bin/dj → dev/django/dj
```

---

## Usage

### Create a new project

```sh
dj start MyProject
```

This will:

* create a project directory
* initialize a pipenv environment
* install Django
* start a project using `config/` as the settings module
* create a `.gitignore`
* initialize a Git repository

---

### Run the development server

```sh
dj run
dj run 8080
```

Runs:

```text
0.0.0.0:<port>
```

(default port is `8000`)

---

### Run any `manage.py` command

```sh
dj migrate
dj startapp blog
dj createsuperuser
```

Commands are executed inside the active project directory.

---

## Philosophy

This tool exists to:

* reduce boilerplate
* keep Django projects consistent
* avoid global installs
* stay out of the way once a project is created

It does not manage:

* Python versions
* production configuration
* deployment

Those concerns belong elsewhere.
