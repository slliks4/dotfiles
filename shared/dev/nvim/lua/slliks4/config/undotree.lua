-- lua/slliks4/config/undotree.lua

-- ==========================
-- Persistent Undo
-- ==========================
vim.opt.undofile = true

local undo_dir = vim.fn.stdpath('data') .. '/undo'
vim.opt.undodir = undo_dir

-- Create undo directory if it doesn't exist
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, "p")
end

-- ==========================
-- Keymaps
-- ==========================
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {
    desc = 'Toggle UndoTree',
    silent = true,
})
