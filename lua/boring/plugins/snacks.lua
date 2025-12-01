return {
    {
        'snacks.nvim',
        for_cat = 'general.extra',
        priority = 1000,
        lazy = false,
        after = function(_)
            require('snacks').setup({
                bigfile = { enabled = true },
                notifier = { enabled = true },
                quickfile = { enabled = true },
                terminal = { enabled = true },
                words = { enabled = true },
            })

            vim.keymap.set('n', '<leader>tt', function()
                require('snacks').terminal.toggle()
            end, { desc = '[T]oggle [T]erminal' })
        end,
    },
}
