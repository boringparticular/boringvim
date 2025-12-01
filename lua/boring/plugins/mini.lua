return {
    {
        'mini.nvim',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        after = function(_)
            local statusline = require('mini.statusline')
            statusline.setup({
                content = {
                    active = function()
                        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                        local git = MiniStatusline.section_git({ trunc_width = 40 })
                        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                        local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
                        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                        local location = MiniStatusline.section_location({ trunc_width = 75 })
                        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

                        local arrow = pcall(require, 'arrow')
                            and {
                                hl = 'ArrowFileIndex',
                                strings = { require('arrow.statusline').text_for_statusline_with_icons() },
                            }

                        return MiniStatusline.combine_groups({
                            { hl = mode_hl, strings = { mode } },
                            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                            arrow,
                            '%<', -- Mark general truncate point
                            { hl = 'MiniStatuslineFilename', strings = { filename } },
                            '%=', -- End left alignment
                            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                            { hl = mode_hl, strings = { search, location } },
                        })
                    end,
                },
            })
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            require('mini.icons').setup()
            require('mini.surround').setup()

            local spec_treesitter = require('mini.ai').gen_spec.treesitter
            require('mini.ai').setup({
                n_lines = 500,
                custom_textobjects = {
                    ['='] = spec_treesitter({ a = '@assignment.outer', i = '@assignment.inner' }),
                    a = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
                    i = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
                    c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
                    f = spec_treesitter({ a = '@call.outer', i = '@call.inner' }),
                    l = spec_treesitter({ a = '@loop.outer', i = '@loop.inner' }),
                    m = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
                },
            })

            require('mini.trailspace').setup()
            -- NOTE: Do i need this in neovim >- 0.10?
            require('mini.comment').setup()
            require('mini.diff').setup()
            require('mini.git').setup()
            require('mini.splitjoin').setup()
            require('mini.move').setup()
            require('mini.sessions').setup({
                autoread = true,
            })
            require('mini.operators').setup()
            require('mini.bracketed').setup()
            require('mini.bufremove').setup()
            require('mini.files').setup()
            require('mini.cursorword').setup()

            -- NOTE: maybe replace this with catgoose/nvim-colorizer.lua
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                    -- Highlight hex color strings (`#212112`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })

            require('mini.animate').setup({
                cursor = { enable = true },
                resize = { enable = true },
                scroll = { enable = false },
                open = { enable = true },
                close = { enable = true },
            })

            -- vim.keymap.set('n', '<C-u>', '<Cmd>lua vim.cmd("normal! <C-u>"); MiniAnimate.execute_after("scroll", "normal! zz")<CR>')
            -- vim.keymap.set('n', '<C-d>', '<Cmd>lua vim.cmd("normal! <C-d>"); MiniAnimate.execute_after("scroll", "normal! zz")<CR>')
            -- vim.keymap.set('n', 'n', '<Cmd>lua vim.cmd("normal! n"); MiniAnimate.execute_after("scroll", "normal! zzvz")<CR>')
            -- vim.keymap.set('n', 'N', '<Cmd>lua vim.cmd("normal! N"); MiniAnimate.execute_after("scroll", "normal! zzvz")<CR>')
        end,
    },
}
