return {
    {
        'nvim-treesitter',
        for_cat = 'general',
        event = 'DeferredUIEnter',
        on_require = 'nvim-treesitter',
        load = function(name)
            vim.cmd.packadd(name)
            if nixCats('treesitter.extra') then
                vim.cmd.packadd('nvim-treesitter-refactor')
            end
            -- vim.cmd.packadd('nvim-treesitter-textobjects')
            -- vim.cmd.packadd('nvim-treesitter-commentstring')
        end,
        after = function(_)
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true

            require('nvim-treesitter.configs').setup({
                refactor = {
                    highlight_current_scope = { enable = true },
                },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
    {
        'nvim-treesitter-context',
        for_cat = 'treesitter.extra',
        dep_of = 'nvim-treesitter',
        after = function(_)
            require('treesitter-context').setup({
                enable = true,
                max_lines = 5,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = 'outer',
                mode = 'cursor',
                separator = nil,
                zindex = 20,
                on_attach = nil,
            })
        end,
    },
}
