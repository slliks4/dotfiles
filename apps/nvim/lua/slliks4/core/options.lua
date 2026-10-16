-- UI
vim.g.netrw_banner = 0
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.cmdheight = 1

-- Editing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Use ripgrep when available
if vim.fn.executable("rg") == 1 then
    -- --glob excludes specific directories/files from searches
    -- ripgrep automatically respects .gitignore, but these add explicit ignores
    vim.opt.grepprg = "rg --vimgrep --smart-case --glob '!{.git,node_modules,dist,build,__pycache__,.venv,venv}/*'"
    vim.opt.grepformat = "%f:%l:%c:%m"
else
    -- Fallback for standard system grep
    vim.opt.grepprg = "grep -n -I -R --exclude-dir={.git,node_modules,dist,build,__pycache__,.venv,venv}"
end

-- File search (:find)
vim.opt.path:append("**")

-- Wildcard ignores (for :find, :edit tab completion, and wildmenu)
vim.opt.wildignore:append({
    "*/.git/*",
    "*/node_modules/*",
    "*/dist/*",
    "*/build/*",
    "*/__pycache__/*",
    "*/.venv/*",
    "*/venv/*",
    "*.o",
    "*.pyc",
})

-- UX
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor
vim.opt.cursorline = true

-- Safety
vim.opt.confirm = true

-- Auto-create directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(ev)
        local dir = vim.fn.fnamemodify(ev.match, ":p:h")

        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- File handling
vim.opt.undofile = true
vim.opt.autoread = true
