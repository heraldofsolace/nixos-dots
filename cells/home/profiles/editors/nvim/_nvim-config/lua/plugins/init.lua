return require('lazy').setup({
     {
        'b3nj5m1n/kommentary',
        config = function()
            require('kommentary.config').use_extended_mappings()
        end
    },
     'sheerun/vim-polyglot',
     'arecarn/vim-crunch',
     'christoomey/vim-tmux-navigator',
     'wellle/context.vim',
     'gcmt/wildfire.vim',
     {
        'glacambre/firenvim',
        build = function() vim.fn['firenvim#install'](0) end
    },
     {
        'npxbr/glow.nvim',
        build = ':GlowInstall',
        cmd = "Glow",
        init = function()
            require('plugins.configs.glow_setup')
        end
    },
     'junegunn/vim-peekaboo',
     {
        'lervag/vimtex',
        config = function()
            require('plugins.configs.vimtex')
        end,
    },
     'tpope/vim-dispatch',
     'tpope/vim-rhubarb',
     'tpope/vim-obsession',
     'tpope/vim-jdaddy',
     {'mrjones2014/legendary.nvim', dependencies='kkharji/sqlite.lua'},
     {
        'kristijanhusak/vim-dadbod-ui',
        config = function()
            require('plugins.configs.dbui')
        end,
    },
     'direnv/direnv.vim',
     {
        'maxbrunsfeld/vim-yankstack',
        config = function()
            require('plugins.configs.yankstack')
        end,
    },
     {
        'puremourning/vimspector',
        build = "python3 install_gadget.py --all --disable-tcl"
    },
     'lewis6991/impatient.nvim',
     {
      "folke/zen-mode.nvim",
      config = function()
        require('plugins.configs.zen_mode')
      end,
      init = function()
        require('plugins.configs.zen_mode_setup')
      end,
      cmd = "ZenMode"
    },

     {
      "folke/twilight.nvim",
      config = function()
        require('plugins.configs.twilight')
      end,
    },
     {
      "folke/todo-comments.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require('plugins.configs.todo_comments')
      end,
    },
     {
        'goolord/alpha-nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            require('plugins.configs.alpha')
        end,
    },
     'michaeljsmith/vim-indent-object',
     {
        'myusuf3/numbers.vim',
        config = function()
            require('plugins.configs.numbers')
        end,
    },
     { 'ms-jpq/coq_nvim',
        branch = 'coq',
        init=function()
            vim.g.coq_settings = { auto_start='shut-up' }
        end,
    },
     { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
     { 'ms-jpq/coq.thirdparty',
            branch = '3p',
            config = function()
                require('plugins.configs.coq')
            end,
        },
     'jubnzv/virtual-types.nvim',
     {
        'ray-x/navigator.lua',
        dependencies = {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
        config = function()
            require('plugins.configs.navigator')
        end,
    },
     {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        config=function()
            require('plugins.configs.nvim_lsp')
        end,
    },
     'nicwest/vim-http',
     {
        'ms-jpq/chadtree', 
        branch = "chad", 
        build = "python3 -m chadtree deps",
        config = function()
            require('plugins.configs.chadtree')
        end,
    },
     'tpope/vim-bundler',
     'tpope/vim-dadbod',
     'tpope/vim-eunuch',
     'tpope/vim-projectionist',
     'tpope/vim-rails',
     'tpope/vim-speeddating',
     {
        'kylechui/nvim-surround',
        config = function()
            require('plugins.configs.surround')
        end,
    },
     {
        'vim-scripts/vim-auto-save',
        config = function()
            require('plugins.configs.autosave')
        end,
    },
     'vimwiki/vimwiki',
     'wakatime/vim-wakatime',
     {
        'lewis6991/gitsigns.nvim',
        dependencies = {'nvim-lua/plenary.nvim'},
        config = function()
            require('plugins.configs.gitsigns')
        end,
    },
     'ryanoasis/vim-devicons',
     {
        'zirrostig/vim-schlepp',
        config = function()
            require('plugins.configs.schlepp')
        end,
    },
     'editorconfig/editorconfig-vim',
     { 'nvim-treesitter/nvim-treesitter',
    config = function()
        require('plugins.configs.treesitter')
    end,
    build = function()
        vf.TSUpdate()
    end},
     'rktjmp/lush.nvim',
     {
        'hoob3rt/lualine.nvim',
        dependencies = {'kyazdani42/nvim-web-devicons', lazy = true},
        config = function()
            require('plugins.configs.lualine')
        end,
    },
     {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require('plugins.configs.indent_blankline')
        end,
    },
     {
        'akinsho/bufferline.nvim',
        version="v2.*",
        dependencies = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('plugins.configs.bufferline')
        end,
    },
     'kdheepak/lazygit.nvim',
     {
        {
          'nvim-telescope/telescope.nvim',
          dependencies = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'telescope-frecency.nvim',
            'lazygit.nvim'
          },
          config = function()
            require("plugins.configs.telescope")
          end,
          cmd = 'Telescope',
          init=function()
            require('plugins.configs.telescope_setup')
          end
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          dependencies = 'kkharji/sqlite.lua',
        },
      },

     {
        'phaazon/hop.nvim',
        name = 'hop',
        config = function()
            require('plugins.configs.hopword')
        end,
    },

     {
        "nvim-neorg/neorg",
        ft = "norg",
        build = ":Neorg sync-parsers",
        config = function()
            require('plugins.configs.neorg')
        end,
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
     'folke/lsp-colors.nvim',
     {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            require('plugins.configs.trouble')
        end,
    },
     {
        "folke/which-key.nvim",
        config = function()
            require('plugins.configs.which_key')
        end,
    },
    { 
        "folke/tokyonight.nvim", 
        config=function()
            require('plugins.configs.tokyonight')
        end 
    }

})

