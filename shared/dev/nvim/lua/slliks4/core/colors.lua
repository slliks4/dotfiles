-- Reset
vim.cmd("highlight clear")
vim.cmd("syntax reset")

vim.o.background = "dark"
vim.g.colors_name = "retro_amber"

-- Palette
local c = {
    fg = "#e5a95c",     -- soft amber
    green = "#98c379",
    red = "#e06c75",
    yellow = "#e5c07b",
    comment = "#7a6a4f",
    line = "#1a1812",
    visual = "#2a261d",
    badge_bg = "#3a3325", -- soft yellow/brown badge
}

local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Transparent base
local transparent = {
    "Normal", "NormalNC", "NormalFloat",
    "EndOfBuffer", "SignColumn", "VertSplit",
    "StatusLine", "StatusLineNC",
}

for _, g in ipairs(transparent) do
    hi(g, { bg = "none" })
end

-- Core text
hi("Directory", { fg = c.green, bold = true })
hi("Normal", { fg = c.fg })
hi("LineNr", { fg = "#5c4a2a" })
hi("CursorLineNr", { fg = c.yellow, bold = true })

-- Cursor & selection
hi("CursorLine", { bg = c.line })
hi("Visual", { fg = c.red, bg = c.visual, bold = true })
hi("VisualNOS", { fg = c.red, bg = c.visual })

-- Syntax
hi("Comment", { fg = c.comment, italic = true })
hi("String", { fg = c.green })
hi("Keyword", { fg = c.yellow, bold = true })
hi("Function", { fg = c.yellow })
hi("Type", { fg = c.green })
hi("Identifier", { fg = c.fg })

-- Diagnostics
hi("Error", { fg = c.red, bold = true })
hi("WarningMsg", { fg = c.yellow })

-- Statusline badge colors
hi("StatusLineNormal",  { fg = c.fg,    bg = c.badge_bg })
hi("StatusLineInsert",  { fg = c.green, bg = c.badge_bg })
hi("StatusLineVisual",  { fg = c.yellow,bg = c.badge_bg })
hi("StatusLineCommand", { fg = c.yellow,bg = c.badge_bg })
hi("StatusLineReplace", { fg = c.red,   bg = c.badge_bg })

hi("StatusLine", { fg = c.fg, bg = "none" })
hi("StatusLineNC", { fg = "#5c4a2a", bg = "none" })

-- Mode colors mapping
local mode_colors = {
    n = "%#StatusLineNormal#",
    i = "%#StatusLineInsert#",
    v = "%#StatusLineVisual#",
    V = "%#StatusLineVisual#",
    [""] = "%#StatusLineVisual#",
    c = "%#StatusLineCommand#",
    R = "%#StatusLineReplace#",
}

-- Mode label (badge)
local function mode_label()
    local m = vim.fn.mode()
    local hl = mode_colors[m] or "%#StatusLineNormal#"

    local name = ({
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        c = "COMMAND",
        R = "REPLACE",
    })[m] or m

    return table.concat({
        hl, "  " .. name .. "  ",
        "%#StatusLine#", " ",
    })
end

-- Short file path
local function short_filename()
    local file = vim.fn.expand("%:t")
    local parent = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")
    return (parent ~= "" and parent ~= ".") and (parent .. "/" .. file) or file
end

-- Final statusline
function _G.StatusLine()
    return table.concat({
        mode_label(),
        "%#StatusLine#",
        " " .. short_filename() .. " %m",
        "%=",
        "%y ",
        "%l:%c ",
        "%p%%",
    })
end

vim.o.statusline = "%!v:lua.StatusLine()"
