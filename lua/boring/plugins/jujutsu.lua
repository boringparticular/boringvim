return {
    {
        'hunk.nvim',
        for_cat = 'jujutsu',
        cmd = { 'DiffEditor' },
        after = function(_)
            require('hunk').setup({})
        end,
    },
    {
        'vim-dirdiff',
        for_cat = 'jujutsu',
        after = function(_)
            --
        end,
    },
    {
        'vim-jjdescription',
        for_cat = 'jujutsu',
        after = function(_)
            --
        end,
    },
}
