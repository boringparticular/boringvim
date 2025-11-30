return {
    {
        'nvim-emmet',
        for_cat = 'off',
        keys = {
            {
                '<leader>xe',
                mode = { 'n', 'v' },
                function()
                    require('nvim-emmet').wrap_with_abbreviation()
                end,
                desc = 'Expand emmet',
            },
        },
        after = function(_)
            vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
        end,
    },
    {
        'emmet_language_server',
        for_cat = 'off',
        enabled = nixCats('lsp'),
        lsp = {
            filetypes = { 'heex', 'html', 'css', 'javascript', 'typescript', 'vue' },
        },
    },
    {
        'emmet-vim',
        for_cat = 'off',
        ft = { 'heex', 'html', 'css', 'javascript', 'typescript', 'vue' },
    },
}
