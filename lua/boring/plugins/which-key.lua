local icons = require('boring.icons')

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
            require('which-key').setup({
                preset = 'classic',
            })

            -- TODO: Improve grouping
            -- TODO: Improve icons
            require('which-key').add({
                { '<leader>u', group = '[U]I' },
                { '<leader>u_', hidden = true },
                { '<leader>c', group = '[C]ode', icon = { icon = icons.code, color = 'blue' } },
                { '<leader>c_', hidden = true },
                { '<leader>r', group = '[R]ename' },
                { '<leader>r_', hidden = true },
                { '<leader>s', group = '[S]earch', icon = { icon = icons.search, color = 'green' } },
                { '<leader>s_', hidden = true },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>t_', hidden = true },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>w_', hidden = true },
                { '<leader>a', group = '[A]I', icon = { icon = icons.ai, color = 'azure' } },
                { '<leader>a_', hidden = true },
                { '<leader>d', group = '[D]ebug', icon = { icon = icons.debug, color = 'red' } },
                { '<leader>d_', hidden = true },
                { '<leader>x', group = 'Diagnostics' },
                { '<leader>x_', hidden = true },
                { '<leader>b', group = '[B]uffer' },
                { '<leader>b_', hidden = true },
                { '<leader>g', group = '[G]it', icon = { icon = icons.git, color = 'orange' } },
                { '<leader>g_', hidden = true },
                {
                    mode = { 'v' },
                    { '<leader>h', group = 'Git [H]unk' },
                    { '<leader>h_', hidden = true },
                },
                { '[', group = 'prev' },
                { ']', group = 'next' },
                { 'g', group = 'goto' },
                { 'gs', group = 'surround' },
                { 'z', group = 'fold' },
                { '<leader>o', group = '[O]verseer' },
                { '<leader>o_', hidden = true },
            })
        end,
    },
}
