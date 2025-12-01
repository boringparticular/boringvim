return {
    {
        'better-escape.nvim',
        event = 'InsertEnter',
        for_cat = 'general.extra',
        after = function(_)
            require('better_escape').setup({})
        end,
    },
}
