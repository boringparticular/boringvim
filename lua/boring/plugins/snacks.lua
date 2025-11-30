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
                    if vim.fn.has('nvim-0.11') == 1 then
                        vim._print = function(_, ...)
                            dd(...)
                        end
                    else
                        vim.print = dd
                    end
                end,
            })
        end,
        after = function(_)
            require('snacks').setup({
                animate = { enabled = true },
                bigfile = { enabled = true },
                debug = { enabled = true },
                dim = { enabled = true },
                git = { enabled = true },
                image = { enabled = true },
                indent = {
                    enabled = false,
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
                        enabled = true,
                        underline = true,
                    },
                    chunk = {
                        enabled = true,
                    },
                },
                input = { enabled = true },
                keymap = { enabled = true },
                layout = { enabled = true },
                lazygit = { enabled = true },
                notifier = { enabled = true },
                notify = { enabled = true },
                quickfile = { enabled = true },
                rename = { enabled = true },
                scratch = { enabled = true },
                terminal = { enabled = true },
                toggle = { enabled = true },
                util = { enabled = true },
                win = { enabled = true },
                words = { enabled = true },
                zen = { enabled = true },
            })
        end,
    },
}
