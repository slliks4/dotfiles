-- Force Neovim (and Mason) to use system Node, not nvm
local system_node_bin = "/usr/bin"

if not vim.env.PATH:match("^" .. system_node_bin) then
  vim.env.PATH = system_node_bin .. ":" .. vim.env.PATH
end

require ("slliks4")
