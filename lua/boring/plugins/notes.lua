return {
    {
        'obsidian.nvim',
        for_cat = 'notes',
        lazy = true,
        ft = 'markdown',
        after = function(_)
            require('obsidian').setup({
                ui = { enable = false },
                workspaces = {
                    {
                        name = 'personal',
                        path = '~/Nextcloud/notes',
                    },
                },
            })
        end,
    },
    {
        'zk-nvim',
        for_cat = 'notes',
        after = function(_)
            require('zk').setup({})
        end,
    },
    {
        'zk',
        for_cat = 'notes',
        enabled = nixCats('lsp'),
        lsp = {},
    },
}
