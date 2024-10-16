require('boring')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- NOTE: nixCats: this is where we define some arguments for the lazy wrapper.
local pluginList = nil
local nixLazyPath = nil
if require('nixCatsUtils').isNixCats then
    local allPlugins = require('nixCats').pawsible.allPlugins
    -- it is called pluginList because we only need to pass in the names
    -- this list literally just tells lazy.nvim not to download the plugins in the list.
    pluginList = require('nixCatsUtils.lazyCat').mergePluginTables(allPlugins.start, allPlugins.opt)

    -- it wasnt detecting that these were already added
    -- because the names are slightly different from the url.
    -- when that happens, add them to the list, then also specify the new name in the lazySpec
    pluginList[ [[Comment.nvim]] ] = ''
    pluginList[ [[LuaSnip]] ] = ''
    -- alternatively you can do it all in the plugins spec instead of modifying this list.
    -- just set the name and then add `dev = require('nixCatsUtils').lazyAdd(false, true)` to the spec

    -- HINT: to view the names of all plugins downloaded via nix, use the `:NixCats pawsible` command.

    -- we also want to pass in lazy.nvim's path
    -- so that the wrapper can add it to the runtime path
    -- as the normal lazy installation instructions dictate
    nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]
end
-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
    if require('nixCatsUtils').isNixCats and type(require('nixCats').settings.unwrappedCfgPath) == 'string' then
        return require('nixCats').settings.unwrappedCfgPath .. '/lazy-lock.json'
    else
        return vim.fn.stdpath('config') .. '/lazy-lock.json'
    end
end
local lazyOptions = {
    lockfile = getlockfilepath(),
}

require('nixCatsUtils.lazyCat').setup(pluginList, nixLazyPath, {
    -- NOTE: nixCats: nix downloads it with a different file name.
    -- tell lazy about that.
    { 'Olical/conjure' },
    { 'PaterJason/cmp-conjure' },

    { 'eraserhd/parinfer-rust', build = require('nixCatsUtils').lazyAdd('cargo build --release') },
    { 'numToStr/Comment.nvim', name = 'comment.nvim', opts = {}, enabled = require('nixCatsUtils').enableForCategory('general') },
    { 'tpope/vim-sleuth', enabled = require('nixCatsUtils').enableForCategory('general') },

    { 'mattn/emmet-vim', enabled = require('nixCatsUtils').enableForCategory('webdev') },
    { 'mireq/large_file', enabled = require('nixCatsUtils').enableForCategory('extra') },
    { 'direnv/direnv.vim', enabled = require('nixCatsUtils').enableForCategory('extra') },
    { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim', enabled = require('nixCatsUtils').enableForCategory('extra') },
    {
        'folke/todo-comments.nvim',
        enabled = require('nixCatsUtils').enableForCategory('extra'),
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = true },
    },
    { import = 'boring.plugins' },
}, lazyOptions)

-- vim: ts=2 sts=2 sw=2 et
