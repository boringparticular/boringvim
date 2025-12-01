return {

    {
        'mini.nvim',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        after = function(_)
            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require('mini.statusline')
            -- set use_icons to true if you have a Nerd Font
            statusline.setup({ use_icons = vim.g.have_nerd_font })

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end
            require('mini.cursorword').setup()

            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            require('mini.splitjoin').setup()

            if nixCats('mini.extra') then
                require('mini.files').setup()
                require('mini.sessions').setup()
                require('mini.visits').setup()
                -- require('mini.bufremove').setup()
                require('mini.indentscope').setup()
                require('mini.completion').setup()
            end

            require('mini.animate').setup({
                cursor = { enable = true },
                resize = { enable = true },
                open = { enable = true },
                close = { enable = true },
            })
            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
}
