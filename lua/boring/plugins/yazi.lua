return {
    {
        'yazi.nvim',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        keys = {},
        after = function(_)
            require('yazi').setup({})
        end,
    },
}
