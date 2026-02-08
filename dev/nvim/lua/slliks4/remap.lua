-- 🧩  REMAP & CORE OPTIONS
-- ─────────────────────────────────────────────
--  UI BEHAVIOR & STATUSLINE
-- ─────────────────────────────────────────────

-- Remove top banner in netrw file explorer
vim.g.netrw_banner = 0

-- Always show global statusline
vim.o.laststatus = 3
vim.o.showmode = false -- handled manually
vim.o.ruler = true
vim.o.cmdheight = 1

-- Define mode highlight groups
local mode_colors = {
    n     = "%#StatusLineNormal#",  -- blue
    i     = "%#StatusLineInsert#",  -- green
    v     = "%#StatusLineVisual#",  -- soft purple
    V     = "%#StatusLineVisual#",  -- visual line
    [""] = "%#StatusLineVisual#",  -- visual block
    c     = "%#StatusLineCommand#", -- command
    R     = "%#StatusLineReplace#", -- replace
}

-- Mode → readable label
local function mode_label()
    local m = vim.fn.mode()
    local hl = mode_colors[m] or "%#StatusLine#"
    local name = ({
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        c = "COMMAND",
        R = "REPLACE",
    })[m] or m
    return hl .. " " .. name .. " "
end

-- Git branch (requires vim-fugitive)
local function git_branch()
    local branch = vim.fn.FugitiveHead()
    return (branch ~= "") and (" " .. branch .. " ") or ""
end

-- Custom short path formatter (just parent + filename)
local function short_filename()
    local fullpath = vim.fn.expand("%:p")
    local tail = vim.fn.expand("%:t")                   -- filename
    local parent = vim.fn.fnamemodify(fullpath, ":h:t") -- parent folder name
    if parent == "" or parent == "." then
        return tail
    end
    return parent .. "/" .. tail
end

-- Construct full statusline dynamically
function _G.SlliksStatusLine()
    return table.concat({
        mode_label(),
        "%#StatusLine#",
        " " .. short_filename() .. " %m %r %h",
        "%=",
        git_branch(),
        "%y ",    -- filetype
        "%l:%c ", -- line:column
        "%p%%",   -- file percentage
    })
end

-- Apply it globally
vim.o.statusline = "%!v:lua.SlliksStatusLine()"

-- ─────────────────────────────────────────────
--  STATUSLINE COLORS (Retro / Default Vim style)
-- ─────────────────────────────────────────────
vim.cmd([[
  highlight StatusLineNormal  ctermfg=7 ctermbg=0 cterm=NONE " white on black
  highlight StatusLineInsert  ctermfg=2 ctermbg=0 cterm=NONE   " green
  highlight StatusLineVisual  ctermfg=6 ctermbg=0 cterm=NONE   " cyan
  highlight StatusLineCommand ctermfg=3 ctermbg=0 cterm=NONE   " yellow
  highlight StatusLineReplace ctermfg=1 ctermbg=0 cterm=NONE   " red

  highlight StatusLine        ctermfg=7 ctermbg=0 cterm=NONE
  highlight StatusLineNC      ctermfg=8 ctermbg=0 cterm=NONE
]])
vim.cmd([[set laststatus=2]])


-- ─────────────────────────────────────────────
--  UI CLEANUP
-- ─────────────────────────────────────────────
-- Transparent Neovim background to blend with Foot/tmux
vim.cmd([[
highlight Normal guibg=NONE ctermbg=NONE
highlight NormalNC guibg=NONE ctermbg=NONE
highlight NormalFloat guibg=NONE ctermbg=NONE
highlight Pmenu guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE ctermbg=NONE
highlight VertSplit guibg=NONE ctermbg=NONE
]])

-- ─────────────────────────────────────────────
--  INDENTATION, SEARCH, LINE SETTINGS
-- ─────────────────────────────────────────────
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable line numbers inside Netrw (explorer)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.wo.number = true
        vim.wo.relativenumber = true
    end,
})

-- ─────────────────────────────────────────────
--  SAFETY FEATURES
-- ─────────────────────────────────────────────

-- Send netrw deletes to Trash instead of permanent rm
vim.g.netrw_use_trash = 1

-- Auto-create folders on save if they don’t exist
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(ev)
        local dir = vim.fn.fnamemodify(ev.match, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Confirm before quitting or overwriting
vim.opt.confirm = true

-- Automatically close deleted files still open in buffer
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    callback = function()
        local file = vim.fn.expand("%:p")
        if file ~= "" and vim.fn.filereadable(file) == 0 then
            vim.cmd("bdelete")
        end
    end,
})

-- Add command to delete file from disk + buffer
vim.api.nvim_create_user_command("RemoveFile", function()
    local file = vim.fn.expand("%")
    os.remove(file)
    vim.cmd("bdelete")
    print("🗑️ Deleted " .. file)
end, {})

-- ─────────────────────────────────────────────
--  KEYMAPS
-- ─────────────────────────────────────────────

vim.g.mapleader = " "

-- Clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set('n', '<leader>Y', '"+yy', { desc = "Yank line to system clipboard" })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = "Paste before from system clipboard" })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = "Cut to system clipboard" })
vim.keymap.set('n', '<leader>D', '"+dd', { desc = "Cut line to system clipboard" })
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"_d', { desc = "Delete without yanking" })
vim.keymap.set('n', '<leader>X', '"_dd', { desc = "Delete line without yanking" })

-- Navigation / Windows
vim.keymap.set({ "n", "i", "v" }, "<C-b>", "<Esc>", { desc = "Escape" })
vim.keymap.set('n', '<leader>e', vim.cmd.Ex, { desc = "File explorer" })
vim.keymap.set("n", "<leader>V", "<C-w>v<C-w>l", { desc = "Split vertical & go right" })
vim.keymap.set("n", "<leader>H", "<C-w>s<C-w>j", { desc = "Split horizontal & go down" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Right window" })

-- Tabs / Buffers
vim.keymap.set('v', '<Tab>', '>gv', { desc = "Indent right" })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = "Indent left" })
vim.keymap.set('n', '<leader>b', '<C-^>', { desc = "Switch to alternate buffer" })

-- File management
vim.keymap.set({ 'n', 'v' }, '<leader>q', ':q<CR>', { desc = "Quit" })
vim.keymap.set({ 'n', 'v' }, '<leader>w', ':w<CR>', { desc = "Save" })
vim.keymap.set('n', '<leader>W', ':wa<CR>', { desc = "Save all files" })

-- JSX comment helpers
vim.keymap.set('n', '<leader>jc', 'i{/* <esc>a */}<esc>', { desc = "jsx comment line" })
vim.keymap.set('x', '<leader>jc', 'c{/* <c-r>" */}<esc>', { desc = "jsx comment selection" })

-- Soften Comments
vim.api.nvim_set_hl(0, "Comment", {
  ctermfg = 3,    -- yellow / amber-ish
  cterm = NONE
})
-- Gentle Cursorline
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {
  ctermbg = 0
})
