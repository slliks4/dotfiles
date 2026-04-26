# nvm — Node Version Manager

This module installs and configures **nvm**, the recommended way to manage
Node.js versions for development.

nvm allows you to:

- install multiple Node versions side-by-side
- switch Node versions per project or globally
- install global npm packages **without sudo**

This keeps Node tooling isolated from the system package manager.

---

## Installation

From the dotfiles root:

```sh
cd dev/nvm
./install.sh
````

This will:

* install `nvm` into `~/.nvm` (if missing)
* create a shell config file at:

```text
~/.config/zsh/conf.d/nvm.zsh
```

* not modify `.zshrc`

---

## Shell Integration

nvm is loaded through your modular shell system:

```sh
~/.config/zsh/conf.d/nvm.zsh
```

Make sure your `.zshrc` sources `conf.d`:

```sh
for file in ~/.config/zsh/conf.d/*.zsh; do
  [ -f "$file" ] && source "$file"
done
```

Restart your shell to activate nvm.

---

## Usage

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

## Why not `sudo npm install -g`?

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

## Verification

```sh
which node
# → ~/.nvm/versions/node/vX.X.X/bin/node

npm list -g --depth=0
```

---

## Notes

* nvm is loaded per shell session
* no system packages are modified
* configuration is isolated and reproducible

---

## Philosophy

Node tooling should be:

* isolated from the system
* reproducible per project
* free of permission issues

This module ensures Node development remains clean and predictable.
