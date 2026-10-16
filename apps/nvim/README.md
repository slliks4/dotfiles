# slliks4 Neovim

A small, plugin-free Neovim configuration built around Neovim's native
features.

The goal is not to recreate a complete IDE. It provides a comfortable editing
environment while remaining easy to understand, modify, and install on
different systems.

## Philosophy

- No plugin manager
- No required plugins
- Minimal external dependencies
- Native Neovim features where practical
- Optional features remain optional
- Every part of the configuration should be understandable

## Installation

Clone the repository and run the installer:

```sh
git clone <repository-url>
cd slliks4-dotfiles/nvim
./install.sh
````

The installer backs up an existing Neovim configuration before installing this
one.

## Shell configuration

Optional shell aliases and environment variables are available in
[`nvim.shell`](./nvim.shell).

They can be copied into your shell configuration if desired.

## Performance Optimization

Some performance Optimizations done 

* [Disable Providers](./docs/disable_providers.md)

## Optional features

The base configuration does not include Tree-sitter, an LSP server, or a plugin
manager.

These features can be added independently without changing the philosophy of
the base configuration.

* [Tree-sitter setup](./docs/treesitter.md)
* LSP setup — documentation can be added when needed

## Reference

See the [configuration reference](./docs/reference.md) for key mappings,
commands, and behaviour.
