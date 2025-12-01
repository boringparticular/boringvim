return {
    {
        'go.nvim',
        for_cat = 'general',
        event = { 'CmdlineEnter' },
        ft = { 'go', 'gomod' },
        after = function(_)
            require('go').setup()
        end,
    },
}
