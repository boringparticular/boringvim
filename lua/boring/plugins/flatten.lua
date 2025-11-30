return {
    {
        'flatten.nvim',
        for_cat = 'extra',
        after = function(_)
            require('flatten').setup({
                window = {
                    open = 'smart',
                },
            })
        end,
    },
}
