return {
    {
        'fidget.nvim',
        for_cat = 'lsp',
        after = function(_)
            require('fidget').setup({})
        end,
    },
}
