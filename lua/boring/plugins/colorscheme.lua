require('catppuccin').setup({
    flavour = 'mocha',
    term_colors = true,
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
-- return {
--     {
--         'catppuccin-nvim',
--         priority = 1000, -- Make sure to load this before all the other start plugins.
--         beforeAll = function(_) end,
--         after = function(_) end,
--     },
-- }
