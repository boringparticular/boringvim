return {
    {
        'snacks.nvim',
        for_cat = 'general',
        priority = 1000,
        lazy = false,
        beforeAll = function(_)
            vim.api.nvim_create_autocmd('User', {
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command
                end,
            })
        end,
        after = function(_)
            require('snacks').setup({
                animate = { enabled = true },
                bigfile = { enabled = true },
                bufdelete = { enabled = true },
                dashboard = { enabled = false },
                debug = { enabled = true },
                dim = { enabled = true },
                explorer = { enabled = false },
                git = { enabled = true },
                gitbrowser = { enabled = false },
                image = { enabled = true },
                indent = {
                    enabled = true,
                    indent = {
                        enabled = true,
                        hl = {
                            'SnacksIndent1',
                            'SnacksIndent2',
                            'SnacksIndent3',
                            'SnacksIndent4',
                            'SnacksIndent5',
                            'SnacksIndent6',
                            'SnacksIndent7',
                            'SnacksIndent8',
                        },
                    },
                    scope = {
                        underline = true,
                    },
                    chunk = {
                        enabled = true,
                    },
                },
                input = { enabled = true },
                layout = { enabled = true },
                layzgit = { enabled = true },
                notifier = { enabled = true },
                notify = { enabled = true },
                picker = { enabled = false },
                profiler = { enabled = false },
                quickfile = { enabled = true },
                -- TODO: add command for oil
                rename = { enabled = true },
                scope = { enabled = true },
                scratch = { enabled = true },
                scroll = { enabled = true },
                -- statuscolumn = { enabled = true },
                terminal = { enabled = true },
                toggle = { enabled = true },
                util = { enabled = true },
                win = { enabled = true },
                words = { enabled = true },
                zen = { enabled = true },
            })

            vim.keymap.set('n', '<leader>tt', function()
                require('snacks').terminal.toggle()
            end, { desc = '[T]oggle [T]erminal' })

            vim.keymap.set('n', '<leader>ss', function()
                require('snacks').picker.smart()
            end, { desc = '[S]search [S]mart' })

            vim.keymap.set('n', '<leader>bd', function()
                require('snacks').bufdelete()
            end, { desc = '[B]uffer [D]elete' })

            vim.keymap.set('n', '<leader>uD', function()
                require('snacks').dim()
            end, { desc = '[U]I [D]im' })

            vim.keymap.set('n', '<leader>gb', function()
                require('snacks').git.blame_line()
            end, { desc = '[G]it [B]lame Line' })

            vim.keymap.set('n', '<leader>gl', function()
                require('snacks').lazygit()
            end, { desc = '[G]it [L]azygit' })

            vim.keymap.set('n', '<leader>n', function()
                require('snacks').notifier.show_history()
            end, { desc = '[N]otifier Show History' })

            vim.keymap.set('n', '<leader>un', function()
                require('snacks').notifier.hide()
            end, { desc = '[U]I Hide [N]otifications' })

            vim.keymap.set('n', '<leader>.', function()
                require('snacks').scratch()
            end, { desc = 'Toggle Scratch Buffer' })

            vim.keymap.set('n', '<leader>S', function()
                require('snacks').scratch.select()
            end, { desc = '[S]elect Scratch Buffer' })

            vim.keymap.set('n', '<leader>z', function()
                require('snacks').zen()
            end, { desc = 'Toggle [Z]en Mode' })

            vim.keymap.set('n', '<leader>Z', function()
                require('snacks').zen.zoom()
            end, { desc = 'Toggle [Z]en Zoom' })
        end,
    },
}
