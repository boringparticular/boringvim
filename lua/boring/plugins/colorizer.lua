return {
    {
        'nvim-colorizer.lua',
        for_cat = 'general.extra',
        event = 'VimEnter',
        afte = function(_)
            require('colorizer').setup({
                user_default_options = {
                    AARRGGBB = true,
                    RGB = true,
                    RRGGBB = true,
                    RRGGBBAA = true,
                    css = true,
                    css_fn = true,
                    hsl_fn = true,
                    mode = 'virtualtext',
                    names = false,
                    rgb_fn = true,
                    tailwind = true,
                    virtualtext = '■',
                },
            })
        end,
    },
}
