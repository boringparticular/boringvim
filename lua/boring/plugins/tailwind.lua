return {
    {
        'tailwindcss-colors.nvim',
        for_cat = 'webdev',
        after = function(_)
            require('tailwindcss-colors').setup({})
        end,
    },
    {
        'tailwind-tools.nvim',
        for_cat = 'webdev',
        after = function(_)
            require('tailwind-tools').setup({})
        end,
    },
}
