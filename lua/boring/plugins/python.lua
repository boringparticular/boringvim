return {
    {
        'basedpyright',
        for_cat = 'languages.python',
        enabled = nixCats('lsp'),
        lsp = {},
    },
    {
        'nvim-dap-python',
        for_cat = 'debug.python',
        on_plugin = { 'nvim-dap' },
        after = function(_)
            require('dap-python').setup({})
        end,
    },
}
