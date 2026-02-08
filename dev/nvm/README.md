# 📘 Cleaned + aligned `README.md`

### `dev/nvm/README.md`

````md
# nvm — Node Version Manager

This directory sets up **nvm**, the recommended way to manage Node.js
versions for development.

nvm allows you to:

- install multiple Node versions side-by-side
- switch Node versions per project or globally
- install global npm packages **without sudo**

This keeps Node tooling isolated from the system package manager.

---

## 📦 Installation

From the dotfiles root:

```sh
cd dev/nvm
./install.sh
````

This will:

* install `nvm` into `~/.nvm` (if missing)
* add the required init block to `.zshrc` (idempotent)
* **not** overwrite any existing shell config

Restart your shell or run:

```sh
source ~/.zshrc
```

---

## 🛠 Usage

Install the latest Node version:

```sh
nvm install node
nvm use node
```

Install a specific version:

```sh
nvm install 18
nvm use 18
```

Set a default version:

```sh
nvm alias default node
```

---

## 🚫 Why not `sudo npm install -g`?

Using system-wide npm installs causes:

* permission issues
* conflicts with pacman-managed files
* breakage after updates

With nvm, global packages install into:

```text
~/.nvm/versions/node/...
```

No sudo. No conflicts.

---

## ✅ Verification

```sh
which node
# → ~/.nvm/versions/node/vX.X.X/bin/node

npm list -g --depth=0
```
