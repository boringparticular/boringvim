require('lze').load({
    { import = 'boring.plugins.snacks' },
    { import = 'boring.plugins.treesitter' },
    { import = 'boring.plugins.mini' },
    { import = 'boring.plugins.fzf' },
    { import = 'boring.plugins.blink' },
    { import = 'boring.plugins.oil' },
    { import = 'boring.plugins.which-key' },
    { import = 'boring.plugins.conform' },
    { import = 'boring.plugins.lint' },
    { import = 'boring.plugins.debug' },
    { import = 'boring.plugins.notes' },
    { import = 'boring.plugins.git' },
    { import = 'boring.plugins.undotree' },
    { import = 'boring.plugins.todo-comments' },
    { import = 'boring.plugins.trouble' },
    { import = 'boring.plugins.flash' },
    { import = 'boring.plugins.fidget' },
    { import = 'boring.plugins.copilot' },
    { import = 'boring.plugins.gitsigns' },
    { import = 'boring.plugins.arrow' },
    { import = 'boring.plugins.better-escape' },
    { import = 'boring.plugins.noice' },
    { import = 'boring.plugins.colorful-menu' },
    { import = 'boring.plugins.lazydev' },
    { import = 'boring.plugins.elixir' },
    { import = 'boring.plugins.tailwind' },
    {
        'direnv.vim',
        for_cat = 'general.extra',
    },
    {
        'vim-sleuth',
        for_cat = 'general',
    },
    {
        'nvim-bqf',
        for_cat = 'general',
        ft = 'qf',
        event = 'DeferredUIEnter',
    },
    {
        'dropbar.nvim',
        for_cat = 'general',
        after = function(_) end,
    },
    {
        'lspsaga.nvim',
        for_cat = 'general.extra',
        after = function(_)
            require('lspsaga').setup({})
        end,
    },
    {
        'outline.nvim',
        for_cat = 'general',
        after = function(_)
            require('outline').setup()
        end,
    },
    {
        'typr',
        for_cat = 'general',
        cmd = { 'Typr', 'TyprStats' },
        load = function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd('volt')
        end,
        after = function(_)
            require('typr').setup({})
        end,
    },
})
