# Browser Setup

This module installs and manages my daily browsers.

Each browser has a defined purpose — based on workflow, not trends.

---

## Browsers & Roles

### 🟢 Zen Browser

Used for:

* Social media
* YouTube
* Discord
* Streaming (Disney+, etc.)

---

### 🔵 Firefox Developer Edition

Used for:

* Development work
* Localhost servers
* Web debugging
* Chatbot sessions

Keeps development isolated from daily browsing.

---

### 🟡 Qutebrowser

Used for:

* School work
* General browsing
* Keyboard-first workflow

Lightweight and distraction-free.

---

## Installation

From the module directory:

```sh
./install.sh
```

This will:

* Install required browsers via `paru`
* Ensure GTK portal backend is installed
* Create `browser-guard` in `~/.local/bin`

Restart your session after installation for portal changes to take effect.

---

## Browser Guard

`browser-guard` checks memory usage.

If any browser exceeds 3GB of RAM, it will be terminated when manually triggered.

This is user-controlled — not automatic.

---

## Philosophy

Browsers are tools.

Each one has a role.
Each one stays in its lane.

No overlap.
No randomness.
No trend-chasing.
