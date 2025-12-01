return {
    {
        'nvim-emmet',
        for_cat = 'general',
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
}
