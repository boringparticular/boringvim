require('lze').load({
    { import = 'boring.plugins.snacks' },
    { import = 'boring.plugins.treesitter' },
    { import = 'boring.plugins.mini' },
    { import = 'boring.plugins.fzf' },
    { import = 'boring.plugins.blink' },
    { import = 'boring.plugins.blink-pairs' },
    { import = 'boring.plugins.oil' },
    { import = 'boring.plugins.which-key' },
    { import = 'boring.plugins.conform' },
    { import = 'boring.plugins.lint' },
    { import = 'boring.plugins.debug' },
    { import = 'boring.plugins.notes' },
    { import = 'boring.plugins.neogit' },
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
    { import = 'boring.plugins.go' },
    { import = 'boring.plugins.tailwind' },
    { import = 'boring.plugins.emmet' },
    { import = 'boring.plugins.yazi' },
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
        for_cat = 'general.extra',
        ft = 'qf',
        event = 'DeferredUIEnter',
    },
    {
        'lspsaga.nvim',
        for_cat = 'lsp',
        after = function(_)
            require('lspsaga').setup({})
        end,
    },
    {
        'outline.nvim',
        for_cat = 'lsp',
        after = function(_)
            require('outline').setup()
        end,
    },
    {
        'typr',
        for_cat = 'typr',
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
        'hlargs',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        after = function(_)
            require('hlargs').setup({})
        end,
    },
    {
        'reactive-nvim',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        enabled = false,
        after = function(_)
            require('reactive').setup({
                load = { 'catppuccin-mocha-cursor', 'catppuccin-mocha-cursorline' },
            })
        end,
    },
    {
        'nvim-ts-autotag',
        for_cat = 'webdev',
        event = { 'BufNewFile', 'BufReadPre' },
        after = function(_)
            require('nvim-ts-autotag').setup({})
        end,
    },
    {
        'kulala.nvim',
        for_cat = 'general.extra',
        ft = { 'http', 'rest' },
        keys = {
            { '<leader>Rs', desc = 'Send request' },
            { '<leader>Ra', desc = 'Send all requests' },
            { '<leader>Rb', desc = 'Open scratchpad' },
        },
        after = function(_)
            require('kulala').setup({})
        end,
    },
    {
        'grug-far.nvim',
        for_cat = 'general.extra',
        cmd = 'GrugFar',
        keys = {
            {
                '<leader>sr',
                function()
                    local grug = require('grug-far')
                    local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                        },
                    })
                end,
                mode = { 'v', 'n' },
                desc = '[S]earch and [R]eplace',
            },
        },
        after = function(_)
            require('grug-far').setup({})
        end,
    },
    {
        'grapple.nvim',
        for_cat = 'general.extra',
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = 'Grapple',
        keys = {
            { '<leader>gm', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
            { '<leader>gM', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
            { '<leader>gn', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
            { '<leader>gp', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
        },
        after = function(_)
            require('grapple').setup({
                icons = true,
                scope = 'git',
            })
        end,
    },
    {
        'portal-nvim',
        for_cat = 'general.extra',
        keys = {
            { '<leader>o', '<cmd>Portal jumplist backward<cr>' },
            { '<leader>i', '<cmd>Portal jumplist forward<cr>' },
        },
        after = function(_)
            require('portal').setup({})
        end,
    },
    {
        'yanky.nvim',
        for_cat = 'general.extra',
        keys = {
            { '<leader>p', '<cmd>YankyRingHistory<CR>', mode = { 'n', 'x' }, desc = 'Open Yank History' },
            { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
            { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
            { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
            { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
            { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
            { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
            { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
            { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indented After Cursor (Linewise)' },
            { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indented Before Cursor (Linewise)' },
            { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indented After Cursor (Linewise)' },
            { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indented Before Cursor (Linewise)' },
            { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and Indent Right' },
            { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and Indent Left' },
            { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put Before and Indent Right' },
            { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put Before and Indent Left' },
            { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put After Applying a Filter' },
            { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put Before Applying a Filter' },
        },
        after = function(_)
            require('yanky').setup({})
        end,
    },
})
