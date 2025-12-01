require('boring.plugins.colorscheme')

require('lze').load({
    -- { import = 'boring.plugins.colorscheme' },
    { import = 'boring.plugins.oil' },
    { import = 'boring.plugins.mini' },
    { import = 'boring.plugins.better-escape' },
    { import = 'boring.plugins.colorizer' },
    { import = 'boring.plugins.snacks' },
    { import = 'boring.plugins.flash' },
    { import = 'boring.plugins.conform' },
    { import = 'boring.plugins.elixir' },
    { import = 'boring.plugins.telescope' },
    { import = 'boring.plugins.treesitter' },
    { import = 'boring.plugins.git' },
    { import = 'boring.plugins.lint' },
    { import = 'boring.plugins.debug' },
    -- { import = 'boring.plugins.notify' },
    { import = 'boring.plugins.cmp' },
    -- { import = 'boring.plugins.blink' },
    { import = 'boring.plugins.lsp' },
    { import = 'boring.plugins.go' },
    { import = 'boring.plugins.gitsigns' },
    { import = 'boring.plugins.notes' },
    -- { import = 'boring.plugins.noice' },
    { import = 'boring.plugins.trouble' },
    { import = 'boring.plugins.blankline' },
    { import = 'boring.plugins.undotree' },
    { import = 'boring.plugins.which-key' },
    { import = 'boring.plugins.ai' },
    { import = 'boring.plugins.arrow' },
    { import = 'boring.plugins.harpoon' },
    {
        'rainbow-delimiters.nvim',
        for_cat = 'general',
    },
    {
        'direnv.vim',
        for_cat = 'general.extra',
    },
    {
        'vim-sleuth',
        for_cat = 'general.always',
    },
    {
        'comment.nvim',
        for_cat = 'general.extra',
    },
    {
        'todo-comments.nvim',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        after = function(_)
            require('todo-comments').setup({
                signs = true,
            })
        end,
    },
    {
        'lspsaga.nvim',
        for_cat = 'general.extra',
        after = function(_)
            require('lspsaga').setup({})
        end,
    },
    {
        'dropbar.nvim',
        for_cat = 'general.extra',
        after = function(_) end,
    },
    {
        'nvim-bqf',
        for_cat = 'general.extra',
        ft = 'qf',
    },
    {
        'quicker-nvim',
        for_cat = 'general.extra',
        after = function(_)
            require('quicker').setup({})
        end,
    },
    {
        'dressing.nvim',
        for_cat = 'general.extra',
        after = function(_)
            require('dressing').setup({})
        end,
    },
    {
        'typr',
        for_cat = 'general.extra',
        cmd = { 'Typr', 'TyprStats' },
        load = function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd('volt')
        end,
        after = function(_)
            require('typr').setup({})
        end,
    },
    {
        'nvim-emmet',
        for_cat = 'webdev',
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
})
