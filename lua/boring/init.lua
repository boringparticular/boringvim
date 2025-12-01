vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('lze').register_handlers(require('nixCatsUtils.lzUtils').for_cat)

require('boring.options')
require('boring.keymaps')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


require('boring.colorscheme')
require('boring.lsp')
require('boring.plugins')
