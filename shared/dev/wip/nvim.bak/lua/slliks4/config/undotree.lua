-- 1) Make sure you have the plugin installed, e.g. with packer.nvim:
require('packer').startup(function(use)
  use 'mbbill/undotree'
  -- …your other plugins…
end)

-- 2) Enable persistent undo (so the tree actually has data)
vim.opt.undofile = true
vim.opt.undodir  = vim.fn.stdpath('data') .. '/undo'

-- 3) Map <leader>u to toggle the Undotree window
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {
  desc = 'Toggle undo history tree',
  silent = true,
})
