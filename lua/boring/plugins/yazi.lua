return {
    {
        'yazi.nvim',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        keys = {},
        after = function(_)
            require('yazi').setup({})
        end,
    },
}
