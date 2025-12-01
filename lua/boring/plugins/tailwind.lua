return {
    {
        'tailwindcss-colors.nvim',
        for_cat = 'languages.tailwind',
        dep_of = 'tailwind-tools.nvim',
        after = function(_)
            require('tailwindcss-colors').setup({})
        end,
    },
    {
        -- NOTE: doesn't work with phoenix and tailwind v4 since there is no tailwind.config.js file
        'tailwind-tools.nvim',
        for_cat = 'languages.tailwind',
        ft = { 'heex', 'html', 'css' },
        after = function(_)
            require('tailwind-tools').setup({
                server = {
                    on_attach = function(_, bufnr)
                        require('tailwindcss-colors').buf_attach(bufnr)
                    end,
                    settings = {
                        experimental = {
                            classRegex = { "tw\\('([^']*)'\\)" },
                        },
                        includeLanguages = {
                            elixir = 'phoenix-heex',
                            heex = 'phoenix-heex',
                        },
                    },
                },
            })
        end,
    },
}
