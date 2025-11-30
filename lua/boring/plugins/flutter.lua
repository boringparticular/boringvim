return {
    {
        'flutter-tools.nvim',
        for_cat = 'flutter',
        after = function(_)
            require('flutter-tools').setup({
                widget_guides = {
                    enabled = true,
                },
            })
        end,
    },
}
