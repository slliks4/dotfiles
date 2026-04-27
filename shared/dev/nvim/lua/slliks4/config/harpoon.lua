-- lua/slliks4/config/harpoon.lua

local harpoon = require("harpoon")
local ui = require("harpoon.ui")

-- ==========================
-- Setup
-- ==========================
harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    }
})

-- ==========================
-- Keymaps
-- ==========================

-- Add file
vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end, { desc = "Harpoon Add File", silent = true })

-- Toggle menu
vim.keymap.set("n", "<leader>A", function()
    ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Menu", silent = true })

-- Quick access (1–9)
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
    end, { desc = "Harpoon " .. i, silent = true })
end
