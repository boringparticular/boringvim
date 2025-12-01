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

require('catppuccin').setup({
    flavour = 'mocha',
    term_colors = true,
    dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.15,
    },
    custom_highlights = function(colors)
        return {
            BlinkCmpKind = { fg = colors.blue },

            BlinkCmpMenu = { fg = colors.text, bg = colors.base },
            -- BlinkCmpMenuBorder = { fg = colors.overlay0, bg = colors.base },
            BlinkCmpMenuBorder = { fg = colors.blue, bg = colors.base },
            BlinkCmpMenuSelection = { bg = colors.surface0 },
            BlinkCmpLabel = { fg = colors.text },
            BlinkCmpLabelDeprecated = { fg = colors.overlay0, style = { 'strikethrough' } },
            -- BlinkCmpDocBorder = { fg = colors.overlay0, bg = colors.base },
            BlinkCmpDocBorder = { fg = colors.blue, bg = colors.base },
            BlinkCmpDoc = { fg = colors.text, bg = colors.base },
            BlinkCmpSignatureHelpActiveParameter = { fg = colors.mauve },
            BlinkCmpSignatureHelpBorder = { fg = colors.blue },
        }
    end,
    integrations = {
        blink_cmp = true,
        cmp = true,
        gitsigns = true,
        rainbow_delimiters = true,
        treesitter_context = true,
        indent_blankline = {
            enabled = true,
            scope_color = 'lavender',
            colored_indent_levels = true,
        },
        flash = true,
        mini = {
            enabled = true,
            indentscope_color = 'lavender',
        },
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
    },
})
vim.cmd.colorscheme('catppuccin')

require('boring.lsp')
require('boring.plugins')
