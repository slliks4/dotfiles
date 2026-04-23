vim.g.mapleader = " "

-- Escape
vim.keymap.set("i", "jk", "<Esc>")

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+yy')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d')

-- Save / Quit
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Windows
vim.keymap.set("n", "<leader>V", "<C-w>v<C-w>l")
vim.keymap.set("n", "<leader>H", "<C-w>s<C-w>j")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- reload and sync updates from disk
vim.keymap.set('n', '<leader><leader>', function()
    vim.cmd('checktime')   -- Sync files with disk
    vim.cmd('edit!')       -- Reload current buffer
    print("Files refreshed!") 
end, { desc = 'Refresh current file and disk' })

-- Explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Indent in visual
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- Clear search
vim.keymap.set("n", "<leader>nh", ":nohl<CR>")
