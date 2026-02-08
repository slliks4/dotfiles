require('telescope').setup {
    extensions = {
        fzf = {},
    }
}

local builtin = require('telescope.builtin')

-- Project find and search
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>ss", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "List Buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help Tags" })

-- Plain fuzzy search
vim.keymap.set("n", "<leader>sf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return
  end

  require("telescope.builtin").live_grep({
    search_dirs = { file },
    prompt_title = "Search in current file",
    previewer = true,
  })
end, { desc = "Search current file (Telescope /)" })

-- Git
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
