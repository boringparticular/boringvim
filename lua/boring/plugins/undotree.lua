return {
    {
        'undotree',
        for_cat = 'general.extra',
        cmd = {
            'UndotreeToggle',
            'UndotreeHide',
            'UndotreeShow',
            'UndotreeFocus',
            'UndotreePersistUndo',
        },
        keys = {
            {
                '<leader>tu',
                vim.cmd.UndotreeToggle,
                desc = '[T]oggle [U]ndoTree',
            },
        },
        after = function(_)
            -- vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, { desc = '[T]oggle [U]ndotree' })
        end,
    },
}
