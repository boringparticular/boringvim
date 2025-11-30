vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('lze').register_handlers({
    require('nixCatsUtils.lzUtils').for_cat,
    require('lzextras').lsp,
})

require('mini.deps').setup()

-- Define config table to be able to pass data between scripts
_G.Config = {}

-- Define custom autocommand group and helper to create an autocommand.
-- Autocommands are Neovim's way to define actions that are executed on events
-- (like creating a buffer, setting an option, etc.).
--
-- See also:
-- - `:h autocommand`
-- - `:h nvim_create_augroup()`
-- - `:h nvim_create_autocmd()`
local gr = vim.api.nvim_create_augroup('custom-config', {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
    local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
    vim.api.nvim_create_autocmd(event, opts)
end

-- Some plugins and 'mini.nvim' modules only need setup during startup if Neovim
-- is started like `nvim -- path/to/file`, otherwise delaying setup is fine
_G.Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later

require('boring.options')
require('boring.keymaps')

require('boring.plugins')
