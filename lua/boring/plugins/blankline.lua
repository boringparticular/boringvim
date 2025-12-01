return {
    {
        'indent-blankline.nvim',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        after = function(_)
            require('ibl').setup({

                indent = {
                    char = { '|', '¦', '┆', '┊' },
                    tab_char = { '|', '¦', '┆', '┊' },
                    highlight = {
                        'RainbowRed',
                        'RainbowYellow',
                        'RainbowBlue',
                        'RainbowOrange',
                        'RainbowGreen',
                        'RainbowViolet',
                        'RainbowCyan',
                    },
                },
                scope = {
                    enabled = true,
                    char = '▎',
                    show_start = true,
                    show_end = true,
                },
            })
        end,
    },
}
