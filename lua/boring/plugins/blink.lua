return {
    {
        'friendly-snippets',
        for_cat = 'general',
        dep_of = { 'blink.cmp' },
    },
    {
        'luasnip',
        for_cat = 'general',
        dep_of = { 'blink.cmp' },
        after = function(_)
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
            luasnip.config.setup({})
        end,
    },
    {
        'blink-copilot',
        for_cat = 'general',
        dep_of = { 'blink.cmp' },
    },
    {
        'blink.cmp',
        for_cat = 'general',
        after = function(_)
            require('blink.cmp').setup({
                keymap = { preset = 'default' },
                sources = {
                    default = { 'lsp', 'buffer', 'snippets', 'path', 'copilot' },
                    providers = {
                        copilot = {
                            name = 'copilot',
                            module = 'blink-copilot',
                            score_offset = 100,
                            async = true,
                        },
                    },
                },
                snippets = { preset = 'luasnip' },
                completion = {
                    menu = {
                        border = 'rounded',
                        draw = {
                            treesitter = { 'lsp' },
                            components = {
                                source_name = {
                                    text = function(ctx)
                                        return '[' .. ctx.source_name .. ']'
                                    end,
                                },
                            },
                            columns = {
                                { 'label', 'label_description', gap = 1 },
                                { 'kind_icon', gap = 1, 'kind' },
                                { 'source_name' },
                            },
                        },
                    },
                    ghost_text = { enabled = true },
                    documentation = { auto_show = true, window = { border = 'rounded' } },
                },
                signature = { window = { border = 'rounded' } },
                cmdline = {
                    enabled = true,
                    completion = {
                        ghost_text = { enabled = true },
                        menu = {
                            auto_show = function(_)
                                return vim.fn.getcmdtype() == ':'
                                -- enable for inputs as well, with:
                                -- or vim.fn.getcmdtype() == '@'
                            end,
                        },
                    },
                },
            })

            vim.api.nvim_create_autocmd('User', {
                pattern = 'BlinkCmpMenuOpen',
                callback = function()
                    vim.b.copilot_suggestion_hidden = true
                end,
            })

            vim.api.nvim_create_autocmd('User', {
                pattern = 'BlinkCmpMenuClose',
                callback = function()
                    vim.b.copilot_suggestion_hidden = false
                end,
            })
        end,
    },
}
