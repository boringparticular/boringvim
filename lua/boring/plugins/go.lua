return {
    {
        'go.nvim',
        for_cat = 'go',
        event = { 'CmdlineEnter' },
        ft = { 'go', 'gomod' },
        after = function(_)
            require('go').setup()
        end,
    },
    {
        'gopls',
        for_cat = 'go',
        enabled = nixCats('lsp'),
        lsp = {},
    },
}
