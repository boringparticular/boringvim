return {
    {
        'aider.nvim',
        for__cat = 'ai.chat',
        keys = {
            { '<leader>Ao', '<cmd>AiderOpen<cr>', desc = '[A]ider [O]pen' },
            { '<leader>Am', '<cmd>AiderAddModifiedFiles<cr>', desc = '[A]ider Add [M]odified Files' },
        },
        aftter = function(_)
            require('aider').setup({})
        end,
    },
}
