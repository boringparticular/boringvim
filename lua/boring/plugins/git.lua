return {
    {
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim', -- required
            'sindrets/diffview.nvim', -- optional - Diff integration
            'nvim-telescope/telescope.nvim', -- optional
        },
        config = function()
            local neogit = require('neogit')
            neogit.setup({})

            vim.keymap.set('n', '<leader>tg', '<cmd>Neogit<CR>', { desc = '[T]oggle Neo[g]it' })
        end,
    },
}
