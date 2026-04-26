# NEOVIM SETUP WITH PACKER LET'S GOOOOOO!

This document contains the full guide and plugin list for setting up a feature-rich Neovim development environment using `packer.nvim`. The setup focuses on performance, familiarity, and extensibility.

---

## 🧩 Installing Packer (Plugin Manager)

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

// FOR TELESCOPE AND LSP...
sudo pacman -S --needed ripgrep fd

In your Neovim config directory (`~/.config/nvim/`), create:

```bash
mkdir -p after/plugin
```

Create `lua/plugins.lua` or `init.lua` and paste:

```lua
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
end)
```

Then run:

```vim
:PackerSync
```

---

## 🔍 Telescope (Fuzzy Finder)

```lua
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  requires = { {'nvim-lua/plenary.nvim'} }
}
```

In `after/plugin/telescope.lua`:

```lua
local builtin = require('telescope.builtin')

-- Project find and search
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = "Project Live Grep" })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- Git
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })

-- Show Lsp Diagnostics in Telescope
-- WorkSpace Diagnostics
vim.keymap.set("n", "<leader>dw", builtin.diagnostics, { desc = "Telescope Diagnostics" })
-- Document diagnostics 
vim.keymap.set('n', '<leader>dd', function()
  builtin.diagnostics({ bufnr = 0 })
end, { desc = "Document Diagnostics (Telescope)" })

```

---

## 🎨 Theme: Rose Pine

```lua
use({
  'rose-pine/neovim',
  as = 'rose-pine',
  config = function()
    vim.cmd('colorscheme rose-pine')
  end
})
```

---

## 🌈 Treesitter

```lua
use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
```

`after/plugin/treesitter.lua`::

```lua
require 'nvim-treesitter.configs'.setup {
  -- List of parser names, or "all"
  ensure_installed = {
    "python", "javascript", "typescript", "tsx", "java",
    "c", "lua", "html", "css", "json", "vim",
    "vimdoc", "query", "markdown", "markdown_inline"
  },

  ignore_install = {},
  sync_install = false,
  auto_install = true,
  modules = {},

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

```

---

## 🧭 Harpoon (Quick File Navigation)

```lua
use {
  'ThePrimeagen/harpoon',
  branch = "harpoon2",
  requires = { "nvim-lua/plenary.nvim" }
}
```

`after/plugin/harpoon.lua`:

```lua
local harpoon = require("harpoon")

harpoon:setup({
  settings = { save_on_toggle = true, sync_on_ui_close = true },
})

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end)
end
```

---

## ⏪ UndoTree

```lua
use ('mbbill/undotree')
```

`after/plugin/undotree.lua`:

```lua
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
```

---

## 🧠 Git with Vim Fugitive

```lua
use ('tpope/vim-fugitive')
```

`after/plugin/fugitive.lua`:

```lua
vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Fugitive Git Interface" })
```

---

## 🛠 LSP Setup

```lua
use { "williamboman/mason.nvim" }
use { "williamboman/mason-lspconfig.nvim" }
use { "neovim/nvim-lspconfig" }
```

`after/plugin/lsp.lua`:

```lua
-- mason setup
require("mason").setup()

-- mason-lspconfig bridge setup
require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",
    "pyright",
    "clangd",
    "jdtls",
    "lua_ls",
    "html",
    "cssls",
    "jsonls",
    "marksman",
    "vimls"
  },
  automatic_installation = true,
})
-- lspconfig setup
local lspconfig = require("lspconfig")

lspconfig.pyright.setup({})
lspconfig.ts_ls.setup {}
lspconfig.clangd.setup({})
lspconfig.jdtls.setup({})
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- this fixes the 'vim' global issue
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- adds Neovim runtime to the workspace
        checkThirdParty = false, -- prevents Lua LSP from suggesting third-party config
      },
      telemetry = { enable = false }, -- disables telemetry
    },
  },
})
lspconfig.html.setup({})
lspconfig.cssls.setup({})
lspconfig.jsonls.setup({})
lspconfig.marksman.setup({})
lspconfig.vimls.setup({})
```

---

## 🔡 Auto-pairs and Auto-tag

```lua
use {
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup {}
  end
}

use {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
```

---

## 🔧 Basic Remaps and Options

```lua
-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Leader key
vim.g.mapleader = " "

-- Delete without yanking
vim.keymap.set('n', '<leader>D', '"_dd', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>X', '"_x', { noremap = true, silent = true })

-- Copy to system clipboard
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+y', { noremap = true, silent = true })

-- Paste from system clipboard
vim.keymap.set({'n', 'v'}, '<leader>P', '"+p', { noremap = true, silent = true })

-- Project view 
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { noremap = true, silent = true })

-- Tab in Normal and Visual Mode
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- Remap <leader>~ to jump to the alternate file (like Ctrl-^)
vim.keymap.set('n', '<leader>`', '<C-^>', { noremap = true, silent = true, desc = "Jump to alternate file" })
```

---

## 📌 Notes

* Use `:PackerSync` whenever you update your plugin list
* Organize plugins in `after/plugin/*.lua` for clean setup
* Stay minimal: only add what you need as you go
* Build understanding before adding new tools

---

