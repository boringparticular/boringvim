return {
    {
        'nvim-lspconfig',
        for_cat = 'extra',
        lsp = function(plugin)
            vim.lsp.config(plugin.name, plugin.lsp or {})
            vim.lsp.enable(plugin.name)
        end,
        before = function(_)
            vim.lsp.config('*', {
                capabilities = {},
            })
        end,
    },
}
