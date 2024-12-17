return {
    {
        'blink-cmp',
        for_cat = 'general.cmp',
        after = function(_)
            require('blink.cmp').setup({
                keymap = { preset = 'default' },
            })
        end,
    },
}
