return {
    {
        'grug-far.nvim',
        for_cat = 'general',
        cmd = 'GrugFar',
        keys = {
            {
                '<leader>sr',
                function()
                    local grug = require('grug-far')
                    local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                        },
                    })
                end,
                mode = { 'v', 'n' },
                desc = '[S]earch and [R]eplace',
            },
        },
        after = function(_)
            require('grug-far').setup({})
        end,
    },
}
