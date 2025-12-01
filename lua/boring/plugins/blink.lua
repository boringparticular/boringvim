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
        'blink-cmp-spell',
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
                    default = {
                        'lsp',
                        'buffer',
                        'snippets',
                        'path',
                        'copilot',
                        'spell',
                    },
                    providers = {
                        copilot = {
                            name = 'copilot',
                            module = 'blink-copilot',
                            score_offset = 100,
                            async = true,
                        },
                        spell = {
                            name = 'spell',
                            module = 'blink-cmp-spell',
                            opts = {
                                -- EXAMPLE: Only enable source in `@spell` captures, and disable it
                                -- in `@nospell` captures.
                                enable_in_context = function()
                                    local curpos = vim.api.nvim_win_get_cursor(0)
                                    local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                                    local in_spell_capture = false
                                    for _, cap in ipairs(captures) do
                                        if cap.capture == 'spell' then
                                            in_spell_capture = true
                                        elseif cap.capture == 'nospell' then
                                            return false
                                        end
                                    end
                                    return in_spell_capture
                                end,
                            },
                        },
                    },
                },
                fuzzy = {
                    sorts = {
                        function(a, b)
                            local sort = require('blink.cmp.fuzzy.sort')
                            if a.source_id == 'spell' and b.source_id == 'spell' then
                                return sort.label(a, b)
                            end
                        end,
                        -- This is the normal default order, which we fall back to
                        'score',
                        'kind',
                        'label',
                    },
                },
                snippets = { preset = 'luasnip' },
                completion = {
                    list = { selection = { preselect = true, auto_insert = false } },
                    menu = {
                        border = 'rounded',
                        draw = {
                            treesitter = { 'lsp' },
                            components = {
                                kind_icon = {
                                    text = function(ctx)
                                        local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                        return kind_icon
                                    end,
                                    highlight = function(ctx)
                                        local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                        return hl
                                    end,
                                },
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
