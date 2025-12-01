return {
    {
        'nvim-treesitter-context',
        for_cat = 'general',
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
        'nvim-treesitter',
        for_cat = 'general',
        event = 'DeferredUIEnter',
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
                    highlight_definitions = { clear_on_cursor_move = true, enable = true },
                },
                highlight = {
                    enable = true,
                    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                    --  If you are experiencing weird indenting issues, add the language to
                    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                    additional_vim_regex_highlighting = { 'ruby' },
                },

                indent = { enable = true, disable = { 'ruby' } },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['a='] = { query = '@assignment.outer', desc = 'Select outer part of assignment' },
                            ['i='] = { query = '@assignment.inner', desc = 'Select inner part of assignment' },
                            ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of assignment' },
                            ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of assignment' },

                            ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
                            ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

                            ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
                            ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

                            ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
                            ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

                            ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
                            ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

                            ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
                            ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

                            ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
                            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
                        },
                    },
                },
            })
        end,
    },
}
