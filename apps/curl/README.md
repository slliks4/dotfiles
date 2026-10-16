# curl

Installs and ensures `curl` is available on the system.

This module:
- installs curl using the system package manager
- provides a consistent dependency for scripts and tools

---

## Installation

```bash
./install.sh
````

---

## Usage

Basic request:

```bash
curl https://example.com
```

Download a file:

```bash
curl -L -o file.tar.gz https://example.com/file.tar.gz
```

Send JSON data:

```bash
curl -X POST https://api.example.com \
  -H "Content-Type: application/json" \
  -d '{"key":"value"}'
```

---

## Notes

* `curl` is used across multiple modules (Discord, scripts, APIs)
* No configuration is applied
* No shell integration is required

---

## Philosophy

curl should be:

* always available
* predictable
* unmodified

This module exists to guarantee that scripts depending on curl do not fail.
