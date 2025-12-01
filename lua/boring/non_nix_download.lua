require('nixCatsUtils.catPacker').setup({
    { 'BirdeeHub/lze' },

    { 'catppuccin/nvim' },

    { 'stevearc/oil.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-lua/plenary.nvim' },

    { 'tpope/vim-sleuth', opt = true },

    { 'Olical/conjure', opt = true },
    { 'PaterJason/cmp-conjure', opt = true },

    { 'eraserhd/parinfer-rust', build = 'cargo build --release', opt = true },

    { 'folke/todo-comments.nvim', opt = true },

    -- ai
    { 'sourcegraph/sg.nvim', opt = true },
    { 'supermaven-inc/supermaven-nvim', opt = true },
    { 'Exafunction/codeium.nvim', opt = true },
    { 'zbirenbaum/copilot.lua', opt = true },
    { 'zbirenbaum/copilot-cmp', opt = true },
    { 'CopilotC-Nvim/CopilotChat.nvim', opt = true },

    { 'mattn/emmet-vim', opt = true },
    { 'mireq/large_file', opt = true },
    { 'direnv/direnv.vim', opt = true },
    { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim', opt = true },

    { 'JoosepAlviste/nvim-ts-context-commentstring', opt = true },
    { 'nvim-treesitter/nvim-treesitter-refactor', opt = true },
    { 'nvim-treesitter/nvim-treesitter-context', opt = true },
    { 'nvim-treesitter/nvim-treesitter-textobjects', opt = true },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', opt = true },

    { 'folke/trouble.nvim', opt = true },

    { 'nvim-telescope/telescope-fzf-native.nvim', build = ':!which make && make', opt = true },
    { 'nvim-telescope/telescope-ui-select.nvim', opt = true },
    { 'nvim-telescope/telescope.nvim', opt = true },

    -- lsp
    { 'williamboman/mason.nvim', opt = true },
    { 'williamboman/mason-lspconfig.nvim', opt = true },
    { 'j-hui/fidget.nvim', opt = true },
    { 'neovim/nvim-lspconfig', opt = true },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim', opt = true },
    { 'ray-x/lsp_signature.nvim', opt = true },
    { 'folke/lazydev.nvim', opt = true },

    -- lint and format
    { 'mfussenegger/nvim-lint', opt = true },
    { 'stevearc/conform.nvim', opt = true },

    -- completion
    { 'onsails/lspkind.nvim', opt = true },
    { 'L3MON4D3/LuaSnip', opt = true, as = 'luasnip' },
    { 'saadparwaiz1/cmp_luasnip', opt = true },
    { 'rafamadriz/friendly-snippets', opt = true },
    { 'hrsh7th/cmp-nvim-lsp', opt = true },
    { 'hrsh7th/cmp-nvim-lua', opt = true },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', opt = true },
    { 'hrsh7th/cmp-path', opt = true },
    { 'hrsh7th/cmp-buffer', opt = true },
    { 'hrsh7th/cmp-cmdline', opt = true },
    { 'dmitmel/cmp-cmdline-history', opt = true },
    { 'hrsh7th/cmp-nvim-lsp-document-symbol', opt = true },
    { 'ray-x/cmp-treesitter', opt = true },
    { 'hrsh7th/nvim-cmp', opt = true },

    -- dap
    { 'nvim-neotest/nvim-nio', opt = true },
    { 'rcarriga/nvim-dap-ui', opt = true },
    { 'theHamsta/nvim-dap-virtual-text', opt = true },
    { 'jay-babu/mason-nvim-dap.nvim', opt = true },
    { 'mfussenegger/nvim-dap', opt = true },
    { 'leoluz/nvim-dap-go', opt = true },

    { 'nvchad/nvim-colorizer.lua', opt = true },
    { 'elixir-tools/elixir-tools.nvim', opt = true },
    { 'folke/flash.nvim', opt = true },
    { 'NeogitOrg/neogit', opt = true },
    { 'sindrets/diffview.nvim', opt = true },
    { 'lukas-reineke/indent-blankline.nvim', opt = true },
    { 'lewis6991/gitsigns.nvim', opt = true },
    { 'folke/which-key.nvim', opt = true },
    { 'mbbill/undotree', opt = true },
    { 'numToStr/Comment.nvim', opt = true, as = 'comment.nvim' },

    -- go
    { 'ray-x/go.nvim', opt = true },
    { 'ray-x/guihua.lua', ot = true },

    -- { 'ThePrimeagen/harpoon', branch = 'harpoon2', opt = true },

    { 'echasnovski/mini.nvim', opt = true },

    { 'folke/noice.nvim', opt = true },
    { 'MunifTanjim/nui.nvim', opt = true },
    { 'rcarriga/nvim-notify', opt = true },

    -- notes
    { 'epwalsh/obsidian.nvim', opt = true },
    {
        'iamcco/markdown-preview.nvim',
        build = ':call mkdp#util#install()',
        opt = true,
    },
    { 'MeanderingProgrammer/render-markdown.nvim', opt = true },
    { 'nvim-neorg/neorg', opt = true },

    { 'folke/snacks.nvim', opt = true },
})
