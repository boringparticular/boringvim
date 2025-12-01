-- TODO: Add missing plugins
require('nixCatsUtils.catPacker').setup({
    { 'BirdeeHub/lze' },
    { 'catppuccin/nvim' },
    { 'nvim-lua/plenary.nvim' },
    { 'echasnovski/mini.nvim' },

    { 'stevearc/oil.nvim' },
    { 'nvim-tree/nvim-web-devicons' },

    { 'tpope/vim-sleuth', opt = true },
    { 'folke/snacks.nvim', opt = true },
    { 'obisdian-nvim/obsidian.nvim', opt = true },
})
