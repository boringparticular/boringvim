return {
    {
        'which-key.nvim',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        keys = {
            {
                '<leader>?',
                function()
                    require('which-key').show({ global = false })
                end,
                desc = 'Buffer Local Keymaps (which-key)',
            },
        },
        after = function(_)
            require('which-key').setup({})

            require('which-key').add({
                { '<leader>c', group = '[C]ode' },
                { '<leader>c_', hidden = true },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>d_', hidden = true },
                { '<leader>r', group = '[R]ename' },
                { '<leader>r_', hidden = true },
                { '<leader>s', group = '[S]earch' },
                { '<leader>s_', hidden = true },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>t_', hidden = true },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>w_', hidden = true },
                {
                    mode = { 'v' },
                    { '<leader>h', group = 'Git [H]unk' },
                    { '<leader>h_', hidden = true },
                },
            })
        end,
    },
}
