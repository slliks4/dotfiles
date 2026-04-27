-- lua/slliks4/config/trouble.lua

-- ==========================
-- Diagnostics UI
-- ==========================
vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    underline = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

-- ==========================
-- Trouble Setup
-- ==========================
require("trouble").setup({
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    use_diagnostic_signs = true,
    focus = true,
})

-- ==========================
-- Keymaps
-- ==========================
local trouble = require("trouble")

vim.keymap.set("n", "<leader>tw", function()
    trouble.toggle("diagnostics")
end, { desc = "Workspace Diagnostics", silent = true })

vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.setloclist({ open = false })
    trouble.toggle("loclist")
end, { desc = "Document Diagnostics", silent = true })

vim.keymap.set("n", "<leader>tq", function()
    trouble.toggle("quickfix")
end, { desc = "Quickfix List", silent = true })

vim.keymap.set("n", "<leader>tr", function()
    trouble.toggle("lsp_references")
end, { desc = "LSP References", silent = true })

vim.keymap.set("n", "<leader>tt", function()
    vim.diagnostic.open_float(nil, {
        focus = false,
        border = "rounded",
        source = "if_many",
    })
end, { desc = "Line Diagnostics", silent = true })
