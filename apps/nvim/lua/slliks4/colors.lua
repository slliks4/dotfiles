vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "retro_amber"

-- Palette
local c = {
  fg = "#e5a95c",       -- soft amber
  green = "#98c379",
  red = "#e06c75",
  yellow = "#e5c07b",
  comment = "#7a6a4f",
  line = "#1a1812",
  visual = "#2a261d",
  badge_bg = "#3a3325", -- soft yellow/brown badge
  dim = "#5c4a2a",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Transparent groups (added WinSeparator and FloatBorder)
local transparent = {
  "NormalNC", "NormalFloat", "FloatBorder",
  "EndOfBuffer", "SignColumn", "VertSplit", "WinSeparator",
  "StatusLine", "StatusLineNC",
}

for _, g in ipairs(transparent) do
  hi(g, { bg = "none" })
end

-- Core text & cursor
hi("Normal", { fg = c.fg, bg = "none" }) -- Single clean Normal definition
hi("Directory", { fg = c.green, bold = true })
hi("LineNr", { fg = c.dim })
hi("CursorLineNr", { fg = c.yellow, bold = true })
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

-- Statusline badge highlights
hi("StatusLineNormal",  { fg = c.fg,     bg = c.badge_bg })
hi("StatusLineInsert",  { fg = c.green,  bg = c.badge_bg })
hi("StatusLineVisual",  { fg = c.yellow, bg = c.badge_bg })
hi("StatusLineCommand", { fg = c.yellow, bg = c.badge_bg })
hi("StatusLineReplace", { fg = c.red,    bg = c.badge_bg })

hi("StatusLine", { fg = c.fg, bg = "none" })
hi("StatusLineNC", { fg = c.dim, bg = "none" })

-- Mode mapping lookup table
local mode_map = {
  n        = { hl = "%#StatusLineNormal#",  name = "NORMAL" },
  i        = { hl = "%#StatusLineInsert#",  name = "INSERT" },
  v        = { hl = "%#StatusLineVisual#",  name = "VISUAL" },
  V        = { hl = "%#StatusLineVisual#",  name = "VISUAL LINE" },
  ["\22"]  = { hl = "%#StatusLineVisual#",  name = "VISUAL BLOCK" }, -- \22 is Ctrl-V
  c        = { hl = "%#StatusLineCommand#", name = "COMMAND" },
  R        = { hl = "%#StatusLineReplace#", name = "REPLACE" },
}

-- Fast mode label function
local function mode_label()
  local m = vim.fn.mode()
  local mode_info = mode_map[m] or { hl = "%#StatusLineNormal#", name = m }
  return mode_info.hl .. "  " .. mode_info.name .. "  %#StatusLine# "
end

-- Optimized StatusLine using native statusline flags where possible
-- %f = relative path, %m = modified flag ([+]), %y = filetype ([python]), %l:%c = line:col, %p%% = percentage
function _G.StatusLine()
  return table.concat({
    mode_label(),
    "%#StatusLine#",
    " %f %m",
    "%=",
    "%y ",
    "%l:%c ",
    "%p%%",
  })
end

vim.o.statusline = "%!v:lua.StatusLine()"
