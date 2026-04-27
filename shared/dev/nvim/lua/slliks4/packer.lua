-- lua/slliks4/packer.lua

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- ==========================
    -- Core Dependencies
    -- ==========================
    use 'nvim-lua/plenary.nvim'

    -- ==========================
    -- LSP (Minimal: TS only via your config)
    -- ==========================
    use 'williamboman/mason.nvim'

    use 'williamboman/mason-lspconfig.nvim'

    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('slliks4.config.lsp')
        end
    }

    -- ==========================
    --  FZF: for telescope
    -- ==========================
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
    }

    -- ==========================
    -- Telescope
    -- ==========================
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('slliks4.config.telescope')
        end
    }

    -- ==========================
    -- Harpoon
    -- ==========================
    use {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('slliks4.config.harpoon')
        end
    }

    -- ==========================
    -- Trouble (Diagnostics UI)
    -- ==========================
    use {
        'folke/trouble.nvim',
        config = function()
            require('slliks4.config.trouble')
        end
    }

    -- ==========================
    -- Undo Tree
    -- ==========================
    use {
        'mbbill/undotree',
        config = function()
            require('slliks4.config.undotree')
        end
    }

    -- ==========================
    -- Discord Presence
    -- ==========================
    use {
        'andweeb/presence.nvim',
        config = function()
            require('slliks4.config.presence')
        end
    }
end)
