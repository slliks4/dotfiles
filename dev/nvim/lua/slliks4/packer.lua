-- lua/slliks4/packer.lua
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        config = function()
            require('slliks4.config.treesitter')
        end
    }

    -- Floating Terminal
    use {
        'akinsho/toggleterm.nvim',
        tag = '*',
        config = function()
            require('slliks4.config.toggleterm')
        end
    }

    -- Commentart by Tpope
    use {
        'tpope/vim-commentary',
        config = function()
            require('slliks4.config.commentary')
        end
    }

    -- Neodev
    use {
        'folke/neodev.nvim',
        config = function()
            require('slliks4.config.neodev')
        end
    }

    -- CMP and dependencies
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            require('slliks4.config.cmp')
        end
    }

    -- Mason + LSP
    use { "williamboman/mason.nvim" }
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require('slliks4.config.lsp')
        end
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('slliks4.config.telescope')
        end
    }

    -- Harpoon
    use {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('slliks4.config.harpoon')
        end
    }

    -- Trouble
    use {
        'folke/trouble.nvim',
        config = function()
            require('slliks4.config.trouble')
        end
    }

    -- UndoTree
    use {
        'mbbill/undotree',
        config = function()
            require('slliks4.config.undotree')
        end
    }

    -- Fugitive
    use {
        'tpope/vim-fugitive',
        config = function()
            require('slliks4.config.fugitive')
        end
    }

    -- Autopairs
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('slliks4.config.autopairs')
        end
    }

    -- Autotag
    use {
        'windwp/nvim-ts-autotag',
        config = function()
            require('slliks4.config.autotag')
        end
    }

    -- Discord Presence
    use {
        'andweeb/presence.nvim',
        config = function()
            require('slliks4.config.presence')
        end
    }

    -- Nvim Surround TPOPE
    use("tpope/vim-surround")
end)
