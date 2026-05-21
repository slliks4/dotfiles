-- lua/slliks4/config/lsp.lua
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",
        "pylsp",
        "eslint",
    },
})

local builtin = require("telescope.builtin")

-- ==========================
-- Shared Attach
-- ==========================
local on_attach = function(_, bufnr)

    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = desc,
        })
    end

    map("<leader>ld", builtin.lsp_definitions, "Definition")
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
-- Runtime State
-- ==========================
local lsp_servers = {
    ts_ls = false,
    pylsp = false,
    eslint = false,
}

-- ==========================
-- Server Configs
-- ==========================
vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    on_attach = on_attach,

    root_markers = {
        "package.json",
        "tsconfig.json",
        ".git",
    },
})

vim.lsp.config("eslint", {
    capabilities = capabilities,
    on_attach = on_attach,

    root_markers = {
        "package.json",
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".git",
    },
})

vim.lsp.config("pylsp", {
    on_attach = on_attach,

    root_markers = {
        "pyproject.toml",
        "requirements.txt",
        ".git",
    },
})

-- ==========================
-- Stop Running Clients
-- ==========================
local function stop_server_clients(server)

    for _, client in ipairs(vim.lsp.get_clients()) do

        if client.name == server then
            vim.lsp.stop_client(client.id)
        end
    end
end

-- ==========================
-- Enable
-- ==========================
local function enable_server(server)

    if lsp_servers[server] then
        return
    end

    lsp_servers[server] = true

    vim.lsp.enable(server)

    vim.notify(
        "Enabled LSP: " .. server,
        vim.log.levels.INFO
    )
end

-- ==========================
-- Disable
-- ==========================
local function disable_server(server)

    if not lsp_servers[server] then
        return
    end

    lsp_servers[server] = false

    stop_server_clients(server)

    vim.notify(
        "Disabled LSP: " .. server,
        vim.log.levels.INFO
    )
end

-- ==========================
-- Toggle
-- ==========================
local function toggle_server(server)

    if lsp_servers[server] then
        disable_server(server)
    else
        enable_server(server)
    end
end

-- ==========================
-- Telescope Manager
-- ==========================
vim.keymap.set("n", "<leader>ls", function()

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")

    local conf =
        require("telescope.config").values

    local actions =
        require("telescope.actions")

    local action_state =
        require("telescope.actions.state")

    local themes =
        require("telescope.themes")

    local items = {}

    for server, enabled in pairs(lsp_servers) do

        local status =
            enabled
            and "[active]"
            or "[inactive]"

        table.insert(items, {
            display = string.format(
                "%-12s %s",
                status,
                server
            ),

            server = server,
        })
    end

    pickers.new(
        themes.get_ivy({
            sorting_strategy = "ascending",
        }),

        {
            prompt_title = "LSP Manager",

            finder = finders.new_table({
                results = items,

                entry_maker = function(entry)

                    return {
                        value = entry,
                        display = entry.display,
                        ordinal = entry.server,
                    }
                end,
            }),

            sorter = conf.generic_sorter({}),

            attach_mappings = function(
                prompt_bufnr,
                map
            )

                local toggle_lsp = function()

                    local selection =
                        action_state
                        .get_selected_entry()

                    if not selection then
                        return
                    end

                    local server =
                        selection.value.server

                    toggle_server(server)

                    actions.close(prompt_bufnr)
                end

                map("i", "<CR>", toggle_lsp)
                map("n", "<CR>", toggle_lsp)

                return true
            end,
        }

    ):find()

end, {
    desc = "LSP Manager",
    silent = true,
})
