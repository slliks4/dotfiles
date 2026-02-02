# dwm Visual Tweaks

This document covers **minor visual adjustments** made to dwm.

The goal is improved clarity, not customization for its own sake.

---

## Active Window Border

The only visual change applied so far is increasing the window border thickness.

In `config.h`:

```c
static const unsigned int borderpx = 3;
````

### Why This Change

* makes the focused window easier to identify
* improves clarity on large or multi-monitor setups
* avoids color-heavy or distracting indicators

No additional visual patches or themes are applied.

---

## Philosophy

Visual changes are kept:

* minimal
* reversible
* functional

More customization can be added later **only if daily use demands it**.
