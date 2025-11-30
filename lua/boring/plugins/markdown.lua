return {
    {
        'markdown-preview.nvim',
        for_cat = 'off',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    {
        'render-markdown.nvim',
        for_cat = 'off',
        after = function(_)
            require('render-markdown').setup({})
        end,
        ft = 'markdown',
    },
}
