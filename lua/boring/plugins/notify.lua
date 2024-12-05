return {
    {
        'rcarriga/nvim-notify',
        enabled = require('nixCatsUtils').enableForCategory('extra'),
        opts = {
            max_width = 80,
            render = 'wrapped-compact',
        },
        config = function()
            vim.keymap.set('n', '<leader>sn', '<cmd>Telescope notify<CR>', { desc = '[S]earch [N]otifications' })
        end,
    },
}
