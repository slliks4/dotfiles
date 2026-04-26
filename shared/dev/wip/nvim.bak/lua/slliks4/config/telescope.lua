require("telescope").setup({
    extensions = {
        fzf = {},
    },
})

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

local ivy = themes.get_ivy({
    previewer = true,
})

-- Project find and search
vim.keymap.set("n", "<leader>ff", function()
    builtin.find_files(ivy)
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>ss", function()
    builtin.live_grep(ivy)
end, { desc = "Live Grep" })

vim.keymap.set("n", "<leader>sb", function()
    builtin.buffers(ivy)
end, { desc = "List Buffers" })

vim.keymap.set("n", "<leader>sh", function()
    builtin.help_tags(ivy)
end, { desc = "Help Tags" })

-- Plain fuzzy search (current buffer)
vim.keymap.set("n", "<leader>sf", function()
    builtin.current_buffer_fuzzy_find(
        themes.get_ivy({
            previewer = false,
            sorting_strategy = "ascending",
        })
    )
end, { desc = "Search text in current file" })

-- Git
vim.keymap.set("n", "<leader>fg", function()
    builtin.git_files(ivy)
end)

vim.keymap.set("n", "<leader>gs", function()
    builtin.git_status(ivy)
end)

vim.keymap.set("n", "<leader>gb", function()
    builtin.git_branches(ivy)
end, { desc = "Git Branches" })
