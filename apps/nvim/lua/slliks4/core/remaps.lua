vim.g.mapleader = " "

-- Escape
vim.keymap.set("i", "jk", "<Esc>")

-- Check whether files changed outside Neovim.
-- With 'autoread' enabled, unchanged buffers reload automatically.
vim.keymap.set("n", "<leader><leader>", "<cmd>checktime<CR>", {
    desc = "Check files for external changes",
})

-- Indent in visual
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- Toggle between last and current file
vim.keymap.set("n", "<leader>b", "<C-^>", { desc = "Previous file", silent = true })
