-- lua/slliks4/config/telescope.lua

local telescope = require("telescope")

telescope.setup({
    defaults = {
        sorting_strategy = "ascending",

        file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist",
            "build",
        },
    },
    pickers = {
        lsp_definitions = { theme = "ivy" },
        lsp_references = { theme = "ivy" },
        lsp_implementations = { theme = "ivy" },
        lsp_type_definitions = { theme = "ivy" },
        lsp_document_symbols = { theme = "ivy" },
        lsp_workspace_symbols = { theme = "ivy" },
        find_files = { theme = "ivy"},
        live_grep = { theme = "ivy"},
        buffers = { theme = "ivy"},
        help_tags = { theme = "ivy"},
        git_files = { theme = "ivy"},
        git_status = { theme = "ivy"},
        git_branches = { theme = "ivy"},
    },

    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")

-- Keymaps (clean now, no theme passing)
vim.keymap.set("n", "<leader>ff", function()
    builtin.find_files({
        hidden = true,
        no_ignore = false,
    })
end, { desc = "Find Files", silent = true })

vim.keymap.set("n", "<leader>ss", builtin.live_grep, { silent = true })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { silent = true })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { silent = true })

vim.keymap.set("n", "<leader>sf", function()
    builtin.current_buffer_fuzzy_find({
        sorting_strategy = "ascending",
        theme = "ivy",
    })
end, { desc = "Search Current File", silent = true })

vim.keymap.set("n", "<leader>fg", builtin.git_files, { silent = true })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { silent = true })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { silent = true })

-- Load fzf
telescope.load_extension("fzf")

-- ==========================
-- Builtins
-- ==========================
local builtin = require("telescope.builtin")

-- ==========================
-- Keymaps
-- ==========================

-- Files
vim.keymap.set("n", "<leader>ff", function()
    builtin.find_files({
        hidden = true,
        no_ignore = false,
    })
end, { desc = "Find Files", silent = true })

-- Grep
vim.keymap.set("n", "<leader>ss", builtin.live_grep, {
    desc = "Live Grep",
    silent = true,
})

-- Buffers
vim.keymap.set("n", "<leader>sb", builtin.buffers, {
    desc = "Buffers",
    silent = true,
})

-- Help
vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
    desc = "Help Tags",
    silent = true,
})

-- Current file search
vim.keymap.set("n", "<leader>sf", function()
    require("telescope.builtin").current_buffer_fuzzy_find(
        require("telescope.themes").get_ivy({
            sorting_strategy = "ascending",
        })
    )
end, { desc = "Search Current File", silent = true })

-- Git
vim.keymap.set("n", "<leader>fg", builtin.git_files, {
    desc = "Git Files",
    silent = true,
})

vim.keymap.set("n", "<leader>gs", builtin.git_status, {
    desc = "Git Status",
    silent = true,
})

vim.keymap.set("n", "<leader>gb", builtin.git_branches, {
    desc = "Git Branches",
    silent = true,
})
