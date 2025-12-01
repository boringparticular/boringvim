return {
    {
        'fzf-lua',
        for_cat = 'general',
        cmd = 'FzfLua',
        on_require = 'fzf-lua',
        keys = {
            {
                mode = 'n',
                '<leader>sh',
                '<cmd>FzfLua helptags<CR>',
                desc = '[S]earch [H]elp',
            },
            {
                mode = 'n',
                '<leader>sk',
                '<cmd>FzfLua keymaps<CR>',
                desc = '[S]earch [K]eymaps',
            },
            {
                mode = 'n',
                '<leader>sf',
                '<cmd>FzfLua files<CR>',
                desc = '[S]earch [F]iles',
            },
            {
                mode = 'n',
                '<leader>ss',
                '<cmd>FzfLua builtin<CR>',
                desc = '[S]earch [S]elect fzf',
            },
            {
                mode = 'n',
                '<leader>sw',
                '<cmd>FzfLua grep_cword<CR>',
                desc = '[S]earch current [W]ord',
            },
            {
                mode = 'n',
                '<leader>sg',
                '<cmd>FzfLua live_grep<CR>',
                desc = '[S]earch by [G]rep',
            },
            {
                mode = 'n',
                '<leader>sd',
                '<cmd>FzfLua diagnostics_document<CR>',
                desc = '[S]earch Document [D]iagnostics',
            },
            {
                mode = 'n',
                '<leader>sD',
                '<cmd>FzfLua diagnostics_workspace<CR>',
                desc = '[S]earch Workspace [D]iagnostics',
            },
            {
                mode = 'n',
                '<leader><leader>',
                '<cmd>FzfLua buffers<CR>',
                desc = '[S]earch Buffers',
            },
            {
                mode = 'n',
                '<leader>r',
                '<cmd>FzfLua resume<CR>',
                desc = '[S]earch [R]esume',
            },
            {
                mode = 'n',
                '<leader>/',
                '<cmd>FzfLua grep_curbuf<CR>',
                desc = '[/] Fuzzily search current buffer',
            },
            {
                mode = 'n',
                '<leader>s.',
                '<cmd>FzfLua oldfiles<CR>',
                desc = '[S]earch Recent Files ("." for repeat)',
            },
        },
        after = function(_)
            require('fzf-lua').setup({
                winopts = {
                    height = 0.85,
                    width = 0.85,
                    row = 0.35,
                    col = 0.5,
                },
                keymap = {
                    builtin = {
                        [1] = true,
                        ['<C-f>'] = 'preview-page-down',
                        ['<C-b>'] = 'preview-page-up',
                    },
                    fzf = {
                        [1] = true,
                        ['ctrl-f'] = 'preview-page-down',
                        ['ctrl-b'] = 'preview-page-up',
                        ['ctrl-d'] = 'half-page-down',
                        ['ctrl-u'] = 'half-page-up',
                        ['ctrl-x'] = 'jump',
                        ['ctrl-q'] = 'select-all+accept',
                    },
                },
            })
            require('fzf-lua').register_ui_select()
            local config = require('fzf-lua.config')
            local actions = require('trouble.sources.fzf').actions
            config.defaults.actions.files['ctrl-t'] = actions.open
        end,
    },
}
