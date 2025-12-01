return {
    {
        'obsidian.nvim',
        for_cat = 'notes',
        lazy = true,
        ft = 'markdown',
        after = function(_)
            require('obsidian').setup({
                workspaces = {
                    {
                        name = 'personal',
                        path = '~/Nextcloud/obsidian',
                    },
                },
            })
        end,
    },
    {
        'markdown-preview.nvim',
        for_cat = 'markdown',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    {
        'render-markdown.nvim',
        for_cat = 'markdown',
        after = function(_)
            require('render-markdown').setup({})
        end,
        ft = 'markdown',
    },
    {
        'zk-nvim',
        for_cat = 'notes',
        after = function(_)
            require('zk').setup({})
        end,
    },
}
