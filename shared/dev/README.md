# Development Environment

Development tools and configurations.

This directory contains tools used for programming and general workflow.
All modules are independent and can be installed individually.

These tools are environment-agnostic and work across:
- X11
- Wayland
- headless systems

Each tool provides its own `README.md` and installation method.

---

## Usage

Navigate to a module and follow its instructions.

Example:

```bash
cd git
./install.sh
````

---

## Scope

This layer includes:

* editors
* shells
* language environments
* version control
* terminal utilities

System-level dependencies are handled separately in:

* `shared/system/README.md`
