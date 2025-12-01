return {
    {
        'rcarriga/nvim-notify',
        enabled = false, -- require('nixCatsUtils').enableForCategory('extra'),
        opts = {
            max_width = 80,
            render = 'wrapped-compact',
        },
        config = function()
            -- vim.notify = require('notify')
            vim.keymap.set('n', '<leader>sn', '<cmd>Telescope notify<CR>', { desc = '[S]earch [N]otifications' })
        end,
    },
}
