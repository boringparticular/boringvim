return {
    {
        'friendly-snippets',
        for_cat = 'general.blink',
        dep_of = { 'blink.cmp' },
    },
    {
        'luasnip',
        for_cat = 'general.blink',
        dep_of = { 'blink.cmp' },
        after = function(_)
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup({})
        end,
    },
    {
        'blink-cmp-copilot',
        for_cat = 'general.blink',
        dep_of = { 'blink.cmp' },
    },
    {
        'blink.cmp',
        for_cat = 'general.blink',
        after = function(_)
            require('blink.cmp').setup({
                keymap = { preset = 'default' },
                --
                --         snippets = {
                --             expand = function(snippet, _)
                --                 require('luasnip').lsp_expand(snippet)
                --             end,
                --             active = function(filter)
                --                 if filter and filter.direction then
                --                     return require('luasnip').jumpable(filter.direction)
                --                 end
                --                 return require('luasnip').in_snippet()
                --             end,
                --             jump = function(direction)
                --                 require('luasnip').jump(direction)
                --             end,
                --         },

                sources = {
                    default = {
                        'lsp',
                        'path',
                        'luasnip',
                        'buffer',
                        'cmdline',
                        'copilot',
                    },
                    --     cmdline = {},
                    --             compat = {},
                    providers = {
                        copilot = {
                            name = 'copilot',
                            module = 'blink-cmp-copilot',
                            score_offset = 100,
                            async = true,
                            transform_items = function(_, items)
                                local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
                                local kind_idx = #CompletionItemKind + 1
                                CompletionItemKind[kind_idx] = 'Copilot'
                                for _, item in ipairs(items) do
                                    item.kind = kind_idx
                                end
                                return items
                            end,
                        },
                    },
                },

                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = 'mono',

                    kind_icons = {
                        Copilot = '',
                        Text = '󰉿',
                        Method = '󰊕',
                        Function = '󰊕',
                        Constructor = '󰒓',

                        Field = '󰜢',
                        Variable = '󰆦',
                        Property = '󰖷',

                        Class = '󱡠',
                        Interface = '󱡠',
                        Struct = '󱡠',
                        Module = '󰅩',

                        Unit = '󰪚',
                        Value = '󰦨',
                        Enum = '󰦨',
                        EnumMember = '󰦨',

                        Keyword = '󰻾',
                        Constant = '󰏿',

                        Snippet = '󱄽',
                        Color = '󰏘',
                        File = '󰈔',
                        Reference = '󰬲',
                        Folder = '󰉋',
                        Event = '󱐋',
                        Operator = '󰪚',
                        TypeParameter = '󰬛',
                    },
                },

                signature = {
                    enabled = true,
                    window = {
                        border = 'rounded',
                    },
                },

                completion = {
                    menu = {
                        border = 'rounded',
                        draw = {
                            treesitter = { 'lsp' },
                            columns = { { 'label', 'label_description', gap = 12 }, { 'kind_icon', 'kind' } },
                        },
                    },

                    documentation = {
                        auto_show = true,
                        window = {
                            border = 'rounded',
                        },
                    },

                    ghost_text = {
                        enabled = true,
                    },
                },
            })
        end,
    },
}
