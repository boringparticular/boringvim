return {
    {
        'go-nvim',
        for_cat = 'general.extra',
        -- dependencies = { -- optional packages
        --     'ray-x/guihua.lua',
        --     'neovim/nvim-lspconfig',
        --     'nvim-treesitter/nvim-treesitter',
        -- },
        after = function(_)
            require('go').setup()
        end,
        event = { 'CmdlineEnter' },
        ft = { 'go', 'gomod' },
    },
}
