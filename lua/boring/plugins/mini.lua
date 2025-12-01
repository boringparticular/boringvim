return {

    {
        'mini.nvim',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        after = function(_)
            local statusline = require('mini.statusline')
            statusline.setup({})
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            require('mini.icons').setup()
            require('mini.surround').setup()
            require('mini.ai').setup({ n_lines = 500 })
        end,
    },
}
