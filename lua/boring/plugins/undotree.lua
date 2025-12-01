return {
    {
        'undotree',
        for_cat = 'general',
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
        after = function(_) end,
    },
}
