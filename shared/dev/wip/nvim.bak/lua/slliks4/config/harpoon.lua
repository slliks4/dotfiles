local harpoon = require("harpoon")

harpoon:setup({
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    }
})

-- Add File
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

-- Show Quick Menu
vim.keymap.set("n", "<leader>A", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Quick access to files
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end)
end
