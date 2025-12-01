return {
    {
        'lazydev.nvim',
        for_cat = 'general',
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
}
