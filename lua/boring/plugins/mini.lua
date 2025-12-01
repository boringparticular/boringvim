return {
    {
        'mini.nvim',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        after = function(_)
            local statusline = require('mini.statusline')
            statusline.setup({})
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            require('mini.icons').setup()
            require('mini.surround').setup()
            require('mini.ai').setup({ n_lines = 500 })
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
            require('mini.files').setup()

            -- NOTE: maybe replace this with catgoose/nvim-colorizer.lua
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                    -- Highlight hex color strings (`#rrggbb`) using that color
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
