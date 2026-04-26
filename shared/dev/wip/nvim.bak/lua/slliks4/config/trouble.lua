-- ─────────────────────────────────────────────
-- 🚨 Trouble + Diagnostic Integration
-- ─────────────────────────────────────────────
local ok, trouble = pcall(require, "trouble")
if not ok then
    vim.notify("Trouble.nvim not found!", vim.log.levels.WARN)
    return
end

-- 🔧 Global Diagnostic UI
vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    underline = true,
    signs = true,
    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
    update_in_insert = false,
    severity_sort = true,
})

-- ⚙️ Trouble Setup
trouble.setup({
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    use_diagnostic_signs = true,
    focus = true,
})

-- 🔄 Helper for toggling
local function toggle_and_focus(mode, opts)
    opts = opts or {}
    trouble.toggle(mode, opts)
    vim.cmd("wincmd p")
end

-- 🧩 Trouble Keymaps
vim.keymap.set("n", "<leader>tw", function()
    toggle_and_focus("diagnostics")
end, { desc = "Trouble: Workspace Diagnostics" })

vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.setloclist({ open = false })
    toggle_and_focus("loclist")
end, { desc = "Trouble: Document Diagnostics" })

vim.keymap.set("n", "<leader>tq", function()
    toggle_and_focus("quickfix")
end, { desc = "Trouble: Quickfix List" })

vim.keymap.set("n", "<leader>tr", function()
    toggle_and_focus("lsp_references")
end, { desc = "Trouble: LSP References" })

vim.keymap.set("n", "<leader>tt", function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded", source = "if_many" })
end, { desc = "Trouble: Show Error Float (Quick Peek)" })
