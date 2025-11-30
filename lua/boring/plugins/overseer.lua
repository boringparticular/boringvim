return {
    {
        'overseer.nvim',
        for_cat = 'extra',
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
        on_require = 'overseer',
        keys = {
            { '<leader>rw', '<cmd>OverseerToggle<cr>', desc = 'Overseer Task list' },
            { '<leader>ro', '<cmd>OverseerRun<cr>', desc = 'Overseer Run task' },
            { '<leader>rq', '<cmd>OverseerQuickAction<cr>', desc = 'Overseer Action recent task' },
            { '<leader>ri', '<cmd>OverseerInfo<cr>', desc = 'Overseer Info' },
            { '<leader>rb', '<cmd>OverseerBuild<cr>', desc = 'Overseer Task Builder' },
            { '<leader>rt', '<cmd>OverseerTaskAction<cr>', desc = 'Overseer Task action' },
            { '<leader>rc', '<cmd>OverseerClearCache<cr>', desc = 'Overseer Clear cache' },
        },
        after = function()
            require('overseer').setup({
                dap = false,
                templates = {
                    'builtin',
                    'user.zig_build',
                    'user.zig_run',
                },
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
