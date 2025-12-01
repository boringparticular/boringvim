vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('lze').register_handlers({
    require('nixCatsUtils.lzUtils').for_cat,
    require('lzextras').lsp,
})

require('boring.options')
require('boring.keymaps')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local icons = require('boring.icons')
-- NOTE: can i disable virtual text for the current line and instead show the virtual line?
vim.diagnostic.config({
    underline = true,
    virtual_text = {
        current_line = false,
        spacing = 4,
        source = 'if_many',
        prefix = function(diagnostic, _, _)
            for d, icon in pairs(icons.diagnostics) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                    return icon
                end
            end
            return '●'
        end,
    },
    virtual_lines = {
        current_line = true,
    },
    severity_sort = true,
    update_in_insert = true,
    float = {
        border = 'rounded',
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
        },
    },
})

require('boring.colorscheme')
require('boring.plugins')
