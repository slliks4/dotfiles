require("mason").setup({})

-- ⚙️ Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- 🧭 On-Attach Keymaps
local builtin = require("telescope.builtin")
local function on_attach(_, bufnr)
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end
    map("n", "<leader>ld", builtin.lsp_definitions, "LSP: Go to Definition")
    map("n", "<leader>li", builtin.lsp_implementations, "LSP: Go to Implementation")
    map("n", "<leader>lt", builtin.lsp_type_definitions, "LSP: Go to Type Definition")
    map("n", "<leader>lr", builtin.lsp_references, "LSP: Find References")
    map("n", "<leader>lh", vim.lsp.buf.hover, "LSP: Hover Info")
    map("n", "<leader>la", vim.lsp.buf.code_action, "LSP: Code Action")
    map("n", "<leader>ln", vim.lsp.buf.rename, "LSP: Rename Symbol")
    map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "LSP: Format File")
    map("n", "<leader>lR", "<cmd>LspRestart<CR>", "LSP: Restart Server")
    map("n", "<leader>lsd", builtin.lsp_document_symbols, "LSP: Document Symbols")
    map("n", "<leader>lsw", builtin.lsp_workspace_symbols, "LSP: Workspace Symbols")
end

-- ─────────────────────────────────────────────
-- SERVER CONFIGURATIONS
-- ─────────────────────────────────────────────

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.stdpath("config") .. "/lua",
                },
            },
        },
    },
})

vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        pylsp = {
            plugins = {
                pylsp_mypy = { enabled = true },
                pyflakes = { enabled = true },
                pycodestyle = { enabled = true },
            },
        },
    },
})

vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        javascript = { suggest = { autoImports = true } },
        typescript = { suggest = { autoImports = true } },
    },
})

vim.lsp.config("eslint", {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { ".eslintrc.js", ".eslintrc.json", ".eslintrc", "package.json", ".git" },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
})

-- 🧠 VERILOG / SYSTEMVERILOG
vim.lsp.config("svlangserver", {
    cmd = { "svlangserver" },
    filetypes = { "verilog", "systemverilog" },
    root_markers = { ".git", ".svlangserver" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        systemverilog = {
            includeIndexing = { "**/*.sv", "**/*.v" },
            excludeIndexing = { "**/build/**", "**/out/**", "**/.git/**" },
            defines = {},
            launchConfiguration = "verible-verilog-lint",
            formatCommand = "verible-verilog-format",
            lintCommand = "verible-verilog-lint",
        },
    },
})

vim.lsp.config("svls", {
    cmd = { "svls" },
    filetypes = { "verilog", "systemverilog" },
    root_markers = { ".git" },
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.lsp.config("asm-lsp", {
    cmd = { "asm-lsp" },
    filetypes = { "asm", "s", "S" },
    root_dir = vim.loop.cwd,
    single_file_support = true,
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "verilog", "systemverilog" },
    callback = function()
        vim.bo.formatprg = "verible-verilog-format --stdin_name % --assume_input_has_tabs false"
    end,
})

-- Simple servers
for _, server in ipairs({ "html", "cssls", "jsonls", "marksman", "vimls", "jdtls" }) do
    vim.lsp.config(server, {
        capabilities = capabilities,
        on_attach = on_attach,
    })
end

-- ─────────────────────────────────────────────
-- ENABLE ALL SERVERS
-- ─────────────────────────────────────────────
local all_servers = {
    "lua_ls", "pylsp", "ts_ls", "eslint",
    "html", "cssls", "jsonls", "marksman",
    "vimls", "jdtls", "svlangserver", "svls", "asm-lsp",
}

vim.lsp.enable(all_servers)

-- ─────────────────────────────────────────────
-- 🔭 TELESCOPE PICKER FOR MANUAL SERVER ENABLE
-- ─────────────────────────────────────────────
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function enable_lsp_server()
    pickers.new({}, {
        prompt_title = "Enable LSP Server",
        finder = finders.new_table({ results = all_servers }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.schedule(function()
                    vim.lsp.enable({ selection[1] })
                    vim.notify("✅ Enabled LSP: " .. selection[1], vim.log.levels.INFO)
                end)
            end)
            return true
        end,
    }):find()
end

vim.keymap.set("n", "<leader>le", enable_lsp_server, { desc = "Telescope: Enable LSP server" })
