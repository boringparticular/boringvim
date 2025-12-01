
return {
    {
        'fidget.nvim',
        for_cat = 'general',
        after = function(_)
            require('fidget').setup({})
        end,
    },
}
