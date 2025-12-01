return {
    {
        'nvim-emmet',
        for_cat = 'emmet',
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
        for_cat = 'emmet',
        enabled = nixCats('lsp'),
        lsp = {
            filetypes = { 'heex', 'html', 'css', 'javascript', 'typescript', 'vue' },
        },
    },
    {
        'emmet-vim',
        for_cat = 'emmet',
        ft = { 'heex', 'html', 'css', 'javascript', 'typescript', 'vue' },
    },
}
