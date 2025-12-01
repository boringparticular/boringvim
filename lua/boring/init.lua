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

if nixCats('lsp') then
    require('boring.lsp')
end

require('boring.plugins')
