# Find and Replace

| Command             | What it does                   |
| ------------------- | ------------------------------ |
| `:%s/foo/bar/g`     | Replace all `foo` with `bar`   |
| `:%s/foo/bar/gc`    | Same, but ask for confirmation |
| `:%s/foo/bar/gi`    | Replace case-insensitive       |
| `:s/foo/bar/g`      | Replace in current line        |
| `:%s/\<foo\>/bar/g` | Replace whole word only        |

---

# Change Inside

```
cib   → change inside ()
ci{   → change inside {}
ci"   → change inside "
ci'   → change inside '
ci`   → change inside `
cit   → change inside <tag>
ciw   → change current word
```

---

# Delete / Change Blocks

```
da{   → delete around {}
di{   → delete inside {}
ca{   → change around {}
```

Very useful for **functions and code blocks**.

---

# Select Blocks (Visual)

```
va{   → select around {}
vi{   → select inside {}
v%    → select to matching brace
```

Good for quickly copying or deleting a whole function.

---

# Navigation (Very Useful)

```
%     → jump to matching brace {} () []
gg    → go to top of file
G     → go to bottom of file
nG    → go to line n
```

Example

```
50G
```

go to line 50.

---

# Word Navigation (Super Important)

```
w     → next word
b     → previous word
e     → end of word
```

Uppercase versions move faster:

```
W B E
```

---

# Line Navigation

```
0     → start of line
^     → first non-blank character
$     → end of line
```

---

# Paragraph / Block Movement

```
}     → next paragraph/block
{     → previous paragraph/block
```

Useful in large files.

---

# Editing

```
o     → open new line below
O     → open new line above
A     → append to end of line
I     → insert at beginning of line
```

---

# Copy / Paste

```
yy    → copy line
p     → paste below
P     → paste above
```

Copy multiple lines:

```
5yy
```

---

# Undo / Redo

```
u     → undo
Ctrl+r → redo
```

---

# Quick Useful Tricks

```
.     → repeat last command
*     → search word under cursor
n     → next search result
N     → previous search result
```

# `=` → indent current line
# `==` → auto-indent current line
# `=ap` → indent paragraph
# `gg=G` → indent / format entire file
# ```→ jump to previous location (exact cursor position)  
# ```
# `''` → jump to previous line location
# `Ctrl + ]` → go to definition (using tags / ctags)
# `Ctrl + t` → return from definition (pop tag stack)
# `:tag <name>` → jump to a specific tag/function
# `:tags` → show tag stack
# `gf` → open file under cursor
# `Ctrl + ^` → switch between current file and previous file
# `ma` → set mark `a`
# `` `a `` → jump to mark `a` (exact position)
# `'a` → jump to mark `a` (line only)
