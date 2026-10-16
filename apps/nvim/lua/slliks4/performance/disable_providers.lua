-- ==============================================================================
-- DISABLE EXTERNAL LANGUAGE PROVIDERS (pynvim, neovim npm, etc.)
-- ==============================================================================
-- Neovim includes fallback providers to support legacy plugins written in
-- non-Lua dynamic languages. When a buffer with a matching filetype is loaded,
-- Neovim automatically shells out to $PATH to check if interpreters/bridges exist.
-- 
-- Since this config is purely plugin-free (built-in Lua/Vimscript only),
-- disabling these checks prevents subshell invocation lag on file open.

local unused_providers = {
  "python3",
  "node",
  "ruby",
  "perl",
}

for _, provider in ipairs(unused_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
