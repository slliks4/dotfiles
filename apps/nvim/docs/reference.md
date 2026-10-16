# Neovim Reference

A small reference for native Vim/Neovim commands I use regularly.

The config intentionally keeps custom mappings minimal so the same workflow
works on machines without my configuration.

---

# Custom Mappings

Leader is `<Space>`.

| Mapping | Action |
| --- | --- |
| `<leader><leader>` | Check for files changed outside Neovim |

Normal Vim registers are otherwise left untouched.

---

# Writing and Quitting

- Save current file.
```vim
:w
````

- Quit current window.

```vim
:q
```

-Save and quit.
```vim
:wq
```
- Quit all windows.

```vim
:qa
```

- Force quit everything and discard changes.
```vim
:qa!
```

---
# System clipboard

## Yank to system to clipboard
```vim
"+y
```

## Yank line to system to clipboard
```vim
"+yy
```

## Paste from system clipboard 
```vim
"+p
```

---

# Files

## Open a file

```vim
:e path/to/file
```

## File under cursor

```vim
gf
```

Open the filename under the cursor.

## Alternate File

```vim
Ctrl-^
```

Switch between the current and previously used file.

---

# Find Files

`:find` searches for files using Vim's `path` option.

The config contains:

```lua
vim.opt.path:append("**")
```

This allows recursive searching below the current working directory.

Check the current directory:

```vim
:pwd
```

Check Vim's search path:

```vim
:set path?
```

Find a file:

```vim
:find main.c
```

Completion works too:

```vim
:find mai<Tab>
```

If multiple files have similar names, continue using `<Tab>` to inspect them.

Change the working directory:

```vim
:cd /path/to/project
```

The current directory matters because `**` recursively searches from there.

---

# Grep

`:grep` searches inside files and places the results into Vim's
**quickfix list**.

Example:

```vim
:grep create_user
```

Or depending on the grep program:

```vim
:grep create_user src/*
```

If `ripgrep` is installed, the config can use it automatically:

```lua
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
end
```

Then:

```vim
:grep create_user
```

searches using ripgrep.

This is optional. Neovim still works when `rg` is unavailable.

---

# Quickfix List

Commands such as `:grep`, `:make`, and some other Vim operations put
results into the **quickfix list**.

Open it:

```vim
:copen
```

Close it:

```vim
:cclose
```

List entries:

```vim
:clist
```

Go to the next result:

```vim
:cnext
```

Short version:

```vim
:cn
```

Go to the previous result:

```vim
:cprev
```

Short version:

```vim
:cp
```

Modern Neovim also provides default mappings:

```text
]q    next quickfix entry
[q    previous quickfix entry
```

Jump to a specific quickfix entry:

```vim
:cc 5
```

Typical workflow:

```text
:grep function_name
        ↓
:copen
        ↓
]q / [q
```

---

# Marks

Marks are saved locations.

## Local Marks

Lowercase marks are local to a file.

Set mark `a`:

```vim
ma
```

Jump to its exact line and column:

```vim
`a
```

Jump to the beginning of its line:

```vim
'a
```

Setting `ma` again simply **overwrites the previous `a` mark**.

---

## Global / File Marks

Uppercase marks can jump between files.

```vim
mA
mB
mC
```

Then from another file or directory:

```vim
`A
```

jumps directly back to the exact position.

Or:

```vim
'A
```

jumps to the marked line.

This can be used like a lightweight native Harpoon:

```text
mA     remember file/location A
mB     remember file/location B
mC     remember file/location C

`A     jump to A
`B     jump to B
`C     jump to C
```

Show marks:

```vim
:marks
```

Delete one mark:

```vim
:delmarks A
```

Delete several:

```vim
:delmarks ABC
```

---

# Jump List

Neovim remembers locations you jump between.

Show the jump list:

```vim
:jumps
```

Move backward:

```text
Ctrl-o
```

Move forward:

```text
Ctrl-i
```

This is useful after:

```text
marks
searches
definitions
gf
large movements
```

---

# Change List

Vim also remembers locations where changes happened.

Show them:

```vim
:changes
```

Previous change location:

```text
g;
```

Next change location:

```text
g,
```

---

# Undo / Redo

Undo:

```text
u
```

Redo:

```text
Ctrl-r
```

Unlike many editors, Vim's undo history is a **tree**.

If you undo something:

```text
A → B → C
```

then return to `B` and make a different change:

```text
A → B → D
```

Vim does not necessarily lose `C`.

Both histories can exist.

---

# Undo History

Show the branches/leaves of the undo tree:

```vim
:undolist
```

Move backward through changes chronologically:

```text
g-
```

Move forward chronologically:

```text
g+
```

These differ from `u` and `Ctrl-r`.

`u` and `Ctrl-r` follow the current undo branch.

`g-` and `g+` move through changes by time, which is useful when the history
has branched.

You can also travel through undo history by time.

Go to approximately five minutes ago:

```vim
:earlier 5m
```

Go forward five minutes:

```vim
:later 5m
```

Other examples:

```vim
:earlier 30s
:earlier 2h
:later 30s
:later 1h
```

Because `undofile` is enabled in the config:

```lua
vim.opt.undofile = true
```

undo history can survive closing and reopening files.

---

# Search

Search forward:

```vim
/foo
```

Search backward:

```vim
?foo
```

Next result:

```text
n
```

Previous result:

```text
N
```

Search for word under cursor:

```text
*
```

Search backward for word under cursor:

```text
#
```

---

# Find and Replace

| Command             | What it does                         |
| ------------------- | ------------------------------------ |
| `:%s/foo/bar/g`     | Replace every `foo` with `bar`       |
| `:%s/foo/bar/gc`    | Replace all, asking for confirmation |
| `:%s/foo/bar/gi`    | Case-insensitive replacement         |
| `:s/foo/bar/g`      | Replace on current line              |
| `:%s/\<foo\>/bar/g` | Replace whole word only              |

---

# Text Objects

Text objects are one of Vim's most useful editing concepts.

The general structure is:

```text
operator + inside/around + object
```

For example:

```text
d i {
│ │ │
│ │ └─ braces
│ └─── inside
└───── delete
```

---

## Change Inside

```text
cib    change inside ()
ci{    change inside {}
ci"    change inside ""
ci'    change inside ''
ci`    change inside ``
cit    change inside HTML/XML tag
ciw    change current word
```

---

## Delete / Change Blocks

```text
da{    delete around {}
di{    delete inside {}
ca{    change around {}
ci{    change inside {}
```

Very useful for functions and code blocks.

---

## Select Blocks

```text
va{    select around {}
vi{    select inside {}
v%     select until matching brace
```

---

# Navigation

## Matching Delimiters

```text
%
```

Jump between matching:

```text
()
{}
[]
```

---

## File Navigation

```text
gg      top of file
G       bottom of file
50G     line 50
```

---

## Word Navigation

```text
w       next word
b       previous word
e       end of word
```

Uppercase versions use whitespace-separated WORDS:

```text
W
B
E
```

---

## Line Navigation

```text
0       start of line
^       first non-blank character
$       end of line
```

---

## Paragraph / Block Navigation

```text
}       next paragraph/block
{       previous paragraph/block
```

---

# Editing

```text
o       open line below
O       open line above
A       append at end of line
I       insert at first non-blank character
```

---

# Yank / Paste

```text
yy      yank line
p       paste after/below
P       paste before/above
```

Multiple lines:

```text
5yy
```
---

# Indentation

Current line:

```text
==
```

Indent according to Vim's indentation rules.

Indent paragraph:

```text
=ap
```

Indent entire file:

```text
gg=G
```

---

# Repeat

Repeat the last change:

```text
.
```

This is especially powerful with operations such as:

```text
ciw
dw
A
```

because the entire edit can be repeated elsewhere.

---

# Previous Locations

Exact previous jump position:

```text
``
```

Previous jump line:

```text
''
```

For a richer history use:

```text
Ctrl-o
Ctrl-i
:jumps
```

---

# Tags

If a tags file exists:

```text
Ctrl-]
```

Jump to definition under cursor.

Return:

```text
Ctrl-t
```

Jump to a named tag:

```vim
:tag function_name
```

Show tag stack:

```vim
:tags
```

---

# Explorer

Open the built-in file explorer:

```vim
:Ex
```

Other useful forms:

```vim
:Sex
```

Horizontal split.

```vim
:Vex
```

Vertical split.

---

# Windows

Create vertical split:

```text
Ctrl-w v
```

Create horizontal split:

```text
Ctrl-w s
```

Move between windows:

```text
Ctrl-w h
Ctrl-w j
Ctrl-w k
Ctrl-w l
```

Close current window:

```text
Ctrl-w c
```

Only keep current window:

```text
Ctrl-w o
```

---

# Registers

## Special & Functional Registers

* `""` **Unnamed Register:** Default destination for yanks and deletes (`p` pastes from here).
* `"_` **Black Hole Register:** Discards deleted text so it doesn't overwrite your primary register (`"_dd`).
* `"+` **System Clipboard:** Integrates with your OS clipboard (`"+y` to copy outside Vim, `"+p` to paste into Vim).
* `"*` **Selection Clipboard:** System primary selection (on Linux/X11, text selected with the mouse).

## Named & Numbered Registers

* `"a` – `"z` **Named Registers:** Explicit storage for text chunks (`"ayiw` yanks word into `a`, `"ap` pastes it).
* `"A` – `"Z` **Append Registers:** Capital letters append to the corresponding register (`"Ayy` appends line to register `a`).
* `"0` **Yank Register:** Holds the most recently yanked text (unaffected by deletes).
* `"1` – `"9` **Delete Registers:** Stores recent line-deletes chronologically (`"1` is newest, `"9` is oldest).

## Read-Only Registers

* `"%` **Current File:** Contains the relative file path.
* `"#` **Alternate File:** Contains the path to the previously opened file/buffer.
* `".` **Last Inserted Text:** Holds the text written during the last insert mode entry.
* `":` **Last Command:** Holds the last executed command-line command (`@:` re-runs it).
* `"/` **Last Search:** Holds the last search pattern.

## Operational Registers

* `"="` **Expression Register:** Evaluates math or script output in insert/normal mode (`"=2+2<CR>p` pastes `4`).

**Verification:** To check what is currently stored in your registers at any time, run `:registers` (or `:reg`).

--- 
