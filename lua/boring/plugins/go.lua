return {
    {
        'go.nvim',
        for_cat = 'off',
        event = { 'CmdlineEnter' },
        ft = { 'go', 'gomod' },
        after = function(_)
            require('go').setup()
        end,
    },
    {
        'gopls',
        for_cat = 'off',
        enabled = nixCats('lsp'),
        lsp = {},
    },
}
