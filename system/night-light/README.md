# Night Light Toggle (Redshift)

This module configures a **manual night light toggle** using `redshift`.

The goal is a setup that is:

* minimal
* manual (no background daemon)
* predictable
* dwm-friendly
* scriptable

No auto scheduling.
No location detection.
No unnecessary services.

Just a keybind.

---

## What This Config Does

* Uses `redshift -O` to set a warm color temperature
* Uses `day_temp` (6500K) for a proper reset
* Avoids killing processes blindly
* Stores state in `/tmp`
* Works cleanly with dwm keybindings
* Resets gamma before applying changes

---

## How It Works

Instead of toggling by killing redshift, this module:

* Explicitly sets:

  * **Night** → 3800K
  * **Day** → 6500K
* Uses a small state file:

```text
/tmp/redshift-night
```

This makes the behavior deterministic and avoids the “darker than normal” issue.

---

## Installation

From the dotfiles root:

```sh
cd system/display/night-light
./install.sh
```

This creates:

```text
~/.local/bin/toggle-night → dotfiles
```

---

## Dependencies

This module requires:

* redshift

On Arch:

```sh
sudo pacman -S redshift
```

---

## Usage

Bind `toggle-night` to a key in `dwm`:

```c
{ MODKEY, XK_n, spawn, {.v = nightcmd } },
```

Then:

```sh
Mod + n
```

Press once → warm mode
Press again → normal mode

---

## Philosophy

Night light should:

* not run in the background all day
* not depend on a desktop environment
* not guess when you want it

It should respond instantly to a keypress and disappear when not needed.

This module exists so color temperature feels solved — and stays out of the way.
