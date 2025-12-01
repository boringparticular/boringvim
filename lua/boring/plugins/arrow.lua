return {
    {
        'arrow.nvim',
        for_cat = 'general',
        after = function(_)
            require('arrow').setup({
                show_icons = true,
                leader_key = ';', -- Recommended to be a single key
                buffer_leader_key = 'm', -- Per Buffer Mappings
            })
        end,
    },
}
