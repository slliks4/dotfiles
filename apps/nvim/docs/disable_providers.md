# Performance Optimizations

## Disabled Providers
Neovim by default searches `$PATH` for external runtime bridges (`pynvim`, `neovim` npm package, `neovim-ruby`, `perl-neovim`) whenever opening certain filetypes (e.g., `.py`, `.js`).

Because this setup uses **zero plugins** and relies entirely on built-in features, these provider checks are explicitly disabled in `lua/disable_providers.lua`:

```lua
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
```

**Why:** Prevents Neovim from spawning background processes (`python3 -c "import pynvim"`) on buffer initialization, ensuring instant file opening times across all directory structures and virtual environments.
