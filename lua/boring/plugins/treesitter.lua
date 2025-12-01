return {
    {
        'nvim-treesitter-context',
        for_cat = 'treesitter',
        dep_of = 'nvim-treesitter',
        after = function(_)
            require('treesitter-context').setup({
                enable = true,
                max_lines = 10,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = 'outer',
                mode = 'cursor',
                separator = nil,
                zindex = 20,
                on_attach = nil,
            })
        end,
    },
    {
        'nvim-treesitter-textobjects',
        for_cat = 'treesitter',
        dep_of = 'mini',
    },
    {
        'nvim-treesitter',
        for_cat = 'treesitter',
        event = 'DeferredUIEnter',
        on_require = 'nvim-treesitter',
        load = function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd('nvim-treesitter-textobjects')
            vim.cmd.packadd('nvim-treesitter-refactor')
            vim.cmd.packadd('nvim-treesitter-commentstring')
        end,
        after = function(_)
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true

            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                refactor = {
                    highlight_current_scope = { enable = true },
                    highlight_definitions = {
                        -- does the same as snack words
                        enable = false,
                        clear_on_cursor_move = true,
                    },
                    navigation = {
                        enable = false,
                        keymaps = {
                            goto_definition = 'gnd',
                            goto_next_usage = '<a-*>',
                            goto_previous_usage = '<a-#>',
                            list_definitions = 'gnD',
                            list_definitions_toc = 'gO',
                        },
                    },
                    smart_rename = { enable = true, keymaps = { smart_rename = '<leader>grr' } },
                },
                highlight = {
                    enable = true,
                    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                    --  If you are experiencing weird indenting issues, add the language to
                    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                    additional_vim_regex_highlighting = { 'ruby' },
                },

                indent = { enable = true, disable = { 'ruby' } },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<C-space>',
                        node_incremental = '<C-space>',
                        scope_incremental = false,
                        node_decremental = '<bs>',
                    },
                },

                textobjects = {
                    move = {
                        enable = true,
                        goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
                        goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
                        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
                        goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
                    },
                },
            })
        end,
    },
}
