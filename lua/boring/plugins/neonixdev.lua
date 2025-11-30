return {
    {
        'lazydev.nvim',
        for_cat = 'trying',
        ft = 'lua',
        on_require = 'lazydev',
        after = function(_)
            require('lazydev').setup({
                library = {
                    {
                        path = require('nixCats').nixCatsPath .. '/lua',
                        words = { 'nixCats' },
                    },
                },
            })
        end,
    },
    {
        'lua_ls',
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
                    hint = {
                        enable = true,
                        arrayIndex = 'Disable',
                        await = true,
                        paramName = 'Disable',
                        paramType = true,
                        semicolon = 'Disable',
                        setType = true,
                    },
                },
            },
        },
    },
    {
        'nixd',
        lsp = {},
    },
    {
        'nil_ls',
        lsp = {},
    },
}
