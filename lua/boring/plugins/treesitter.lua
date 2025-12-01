return {
    {
        'nvim-treesitter',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        after = function(_)
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true

            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                    --  If you are experiencing weird indenting issues, add the language to
                    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                    additional_vim_regex_highlighting = { 'ruby' },
                },

                indent = { enable = true, disable = { 'ruby' } },
            })
        end,
    },
}
