return {
    {
        'colorful-menu.nvim',
        for_cat = 'general',
        on_require = 'colorful-menu',
        after = function(_)
            require('colorful-menu').setup({})
        end,
    },
}
