return {
    {
        'fyler.nvim',
        for_cat = 'extra',
        after = function(_)
            require('fyler').setup({})
        end,
    },
}
