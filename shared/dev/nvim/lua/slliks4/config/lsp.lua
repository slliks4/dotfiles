-- lua/slliks4/config/lsp.lua

require("mason").setup()
require("mason-lspconfig").setup()

-- ==========================
-- Toggle State
-- ==========================
local lsp_enabled = true

vim.api.nvim_create_user_command("LspToggle", function()
    lsp_enabled = not lsp_enabled

    if lsp_enabled then
        vim.notify("LSP Enabled")
        vim.lsp.enable("tsserver")
    else
        vim.notify("LSP Disabled")
        vim.lsp.stop_client(vim.lsp.get_active_clients())
    end
end, {})

-- ==========================
-- On Attach
-- ==========================
local builtin = require("telescope.builtin")

local on_attach = function(_, bufnr)
    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = desc,
        })
    end

    map("<leader>ld", builtin.lsp_definitions, "Go to Definition")
    map("<leader>lr", builtin.lsp_references, "References")
    map("<leader>li", builtin.lsp_implementations, "Implementation")
    map("<leader>lt", builtin.lsp_type_definitions, "Type Definition")

    map("<leader>lh", vim.lsp.buf.hover, "Hover")
    map("<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("<leader>ln", vim.lsp.buf.rename, "Rename")
    map("<leader>lf", function()
        vim.lsp.buf.format({ async = true })
    end, "Format")
end

-- ==========================
-- Define TS/JS server
-- ==========================
vim.lsp.config("tsserver", {
    cmd = { "typescript-language-server", "--stdio" },

    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "css",
    },

    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },

    on_attach = function(client, bufnr)
        if not lsp_enabled then return end
        on_attach(client, bufnr)
    end,
})

-- ==========================
-- Enable by default
-- ==========================
if lsp_enabled then
    vim.lsp.enable("tsserver")
end
