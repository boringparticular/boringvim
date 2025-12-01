return {
    {
        'tailwindcss-colors.nvim',
        for_cat = 'general',
        dep_of = 'tailwind-tools.nvim',
        after = function(_)
            require('tailwindcss-colors').setup({})
        end,
    },
    {
        'tailwind-tools.nvim',
        for_cat = 'general',
        after = function(_)
            require('tailwind-tools').setup({
                server = {
                    on_attach = function(_, bufnr)
                        require('tailwindcss-colors').buf_attach(bufnr)
                    end,
                },
            })
        end,
    },
}
