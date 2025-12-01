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
                '<leader>uu',
                vim.cmd.UndotreeToggle,
                desc = '[U]I [U]ndoTree',
            },
        },
        after = function(_) end,
    },
}
