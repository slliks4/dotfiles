-- 1. DISABLE PROVIDERS (Must run before anything else to prevent $PATH scanning)
require("slliks4.performance.disable_providers")

-- 2. CORE SETTINGS
require("slliks4.core.options")
require("slliks4.core.remaps")

-- 3. COLOR & SYNTAX CONFIGURATION
vim.cmd("syntax enable")
vim.cmd("highlight clear")
vim.cmd("syntax reset")
require("slliks4.colors")
