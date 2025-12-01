return {
    {
        'neogit',
        for_cat = 'general.extra',
        keys = {
            { '<leader>tg', '<cmd>Neogit kind=floating<CR>', desc = '[T]oggle Neo[g]it' },
        },
        after = function(_)
            local neogit = require('neogit')
            neogit.setup({})
            --
            -- vim.keymap.set('n', '<leader>tg', '<cmd>Neogit kind=floating<CR>', { desc = '[T]oggle Neo[g]it' })
        end,
    },
}
