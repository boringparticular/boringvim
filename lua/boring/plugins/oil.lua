return {
    {
        'oil.nvim',
        for_cat = 'general',
        after = function(_)
            require('oil').setup({
                default_file_explorer = true,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                use_default_keymaps = true,
                lsp_file_method = {
                    autosave_changes = true,
                },
                buf_options = {
                    buflisted = false,
                    bufhidden = 'hide',
                },
                view_options = {
                    show_hidden = true,
                },
            })
        end,
        keys = { { '-', '<cmd>Oil<CR>', desc = 'Open parent directory' } },
        cmd = 'Oil',
    },
}
