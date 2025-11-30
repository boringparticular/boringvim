return {
    {
        'basedpyright',
        for_cat = 'python',
        enabled = nixCats('lsp'),
        lsp = {},
    },
}
