return {
    {
        'todo-comments.nvim',
        for_cat = 'general.extra',
        event = 'DeferredUIEnter',
        after = function(_)
            require('todo-comments').setup({
                signs = true,
            })
        end,
    },
}
