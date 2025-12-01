return {
    {
        'nvim-notify',
        for_cat = { 'general.extra', default = false },
        config = function()
            vim.notify = require('notify').setup({
                max_width = 80,
                render = 'wrapped-compact',
            })
            vim.keymap.set('n', '<leader>sn', '<cmd>Telescope notify<CR>', { desc = '[S]earch [N]otifications' })
        end,
    },
}
