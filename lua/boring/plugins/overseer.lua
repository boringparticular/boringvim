return {
    {
        'overseer.nvim',
        for_cat = 'general.extra',
        cmd = {
            'OverseerOpen',
            'OverseerClose',
            'OverseerToggle',
            'OverseerSaveBundle',
            'OverseerLoadBundle',
            'OverseerDeleteBundle',
            'OverseerRunCmd',
            'OverseerRun',
            'OverseerInfo',
            'OverseerBuild',
            'OverseerQuickAction',
            'OverseerTaskAction',
            'OverseerClearCache',
        },
        keys = {
            { '<leader>ow', '<cmd>OverseerToggle<cr>', desc = '[O]verseer Task list' },
            { '<leader>oo', '<cmd>OverseerRun<cr>', desc = '[O]verseer Run task' },
            { '<leader>oq', '<cmd>OverseerQuickAction<cr>', desc = '[O]verseer Action recent task' },
            { '<leader>oi', '<cmd>OverseerInfo<cr>', desc = '[O]verseer [I]nfo' },
            { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = '[O]verseer Task [B]uilder' },
            { '<leader>ot', '<cmd>OverseerTaskAction<cr>', desc = '[O]verseer [T]ask action' },
            { '<leader>oc', '<cmd>OverseerClearCache<cr>', desc = '[O]verseer [C]lear cache' },
        },
        after = function()
            require('overseer').setup({
                dap = false,
                form = {
                    win_opts = {
                        winblend = 0,
                    },
                },
                confirm = {
                    win_opts = {
                        winblend = 0,
                    },
                },
                task_win = {
                    win_opts = {
                        winblend = 0,
                    },
                },
            })
        end,
    },
}
