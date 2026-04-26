local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

configs.setup({
  ensure_installed = {
    "python", "javascript", "typescript", "tsx", "java",
    "c", "lua", "html", "css", "scss", "json", "vim",
    "vimdoc", "query", "markdown", "markdown_inline",
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
