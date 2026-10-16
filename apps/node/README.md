# Node.js

Minimal user-local Node.js setup using manually managed binaries and a `current` symlink.

## Install

Create the install directory:

```bash
mkdir -p ~/.local/share/node
cd ~/.local/share/node
```

Download a Node.js binary from:

[Node.js release archive](https://nodejs.org/dist/?utm_source=chatgpt.com)

Example:

```bash
wget https://nodejs.org/dist/v22.15.0/node-v22.15.0-linux-x64.tar.xz
```

Extract:

```bash
tar -xvJf node-v22.15.0-linux-x64.tar.xz
```

Create the active symlink:

```bash
ln -sfn node-v22.15.0-linux-x64 current
```

---

## Zsh

Create:

```text
~/.config/zsh/conf.d/node.zsh
```

Add:

```bash
export PATH="$HOME/.local/share/node/current/bin:$PATH"
```

Ensure your `~/.zshrc` loads files from `conf.d`.

Example:

```bash
for file in ~/.config/zsh/conf.d/*.zsh; do
    source "$file"
done
```

Reload shell:

```bash
source ~/.zshrc
```

---

## Verify

```bash
node -v
npm -v
npx -v
```

---

## Switching Versions

Install another Node.js version and repoint `current`:

```bash
cd ~/.local/share/node

ln -sfn node-v24.8.0-linux-x64 current
```

Reload shell if needed:

```bash
source ~/.zshrc
```
