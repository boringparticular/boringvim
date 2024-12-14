require('nixCatsUtils').setup({
    non_nix_value = true,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.have_nerd_font = nixCats('have_nerd_font')

require('boring.options')
require('boring.keymaps')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
