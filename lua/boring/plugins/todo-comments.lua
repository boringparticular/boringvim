return {
        {
        'todo-comments.nvim',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        after = function(_)
            require('todo-comments').setup({
                signs = true,
            })
        end,
    },
}
