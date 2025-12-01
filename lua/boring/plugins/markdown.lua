return {
    {
        'markdown-preview.nvim',
        for_cat = 'languages.markdown',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    {
        'render-markdown.nvim',
        for_cat = 'languages.markdown',
        after = function(_)
            require('render-markdown').setup({})
        end,
        ft = 'markdown',
    },
}
