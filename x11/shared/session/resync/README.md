# Session Resync

This provides a manual **session re-synchronization script**.

It exists to recover cleanly from:

- monitor unplug / replug
- sleep / wake
- docking changes
- input state inconsistencies

No daemons.  
No automatic hotplug logic.  
No window manager patches.

Just a manual reset entrypoint.

---

## How It Works

The script lives at:

```text
~/.local/bin/resync-session
````

It is created automatically by modules that need it.

Modules append their own commands to the script during installation.

Examples include:

* display configuration
* keyboard setup
* input configuration

The script simply executes all registered actions in order.

---

## Usage

Bind it in your window manager.

Example (i3):

```bash
bindsym $mod+Shift+r exec resync-session
```

Then press:

```
Mod + Shift + R
```

Use it whenever the session feels out of sync.

---

## Notes

* the script is generated and managed automatically
* modules are responsible for adding and removing their own blocks
* safe to run at any time

---

## Philosophy

Session state should be:

* explicit
* reproducible
* manually recoverable

This avoids:

* background daemons
* hidden state
* unpredictable behavior

The system remains simple, transparent, and under your control.
