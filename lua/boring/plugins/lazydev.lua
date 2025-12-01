return {
    {
        'lazydev.nvim',
        for_cat = 'neonixdev',
        ft = 'lua',
        on_require = 'lazydev',
        after = function(_)
            require('lazydev').setup({
                library = {
                    { path = require('nixCats').nixCatsPath .. '/lua', words = { 'nixCats' } },
                },
            })
        end,
    },
    {
        'lua_ls',
        enabled = nixCats('languages.lua') or nixCats('neonixdev'),
        lsp = {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = 'Replace',
                    },
                    diagnostics = {
                        globals = { 'nixCats', 'vim' },
                        disable = { 'missing-fields' },
                    },
                    runtime = {
                        version = 'LuaJIT',
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                },
            },
        },
    },
    {
        'nixd',
        for_cat = 'neonixdev',
        lsp = {},
    },
    {
        'nil_ls',
        for_cat = 'neonixdev',
        lsp = {},
    },
}
