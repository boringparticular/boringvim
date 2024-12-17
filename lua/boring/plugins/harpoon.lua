return {
    {
        'harpoon2',
        for_cat = 'general.extra',
        event = 'VimEnter',
        after = function(_)
            local harpoon = require('harpoon')

            harpoon:setup()

            -- basic telescope configuration
            local conf = require('telescope.config').values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require('telescope.pickers')
                    .new({}, {
                        prompt_title = 'Harpoon',
                        finder = require('telescope.finders').new_table({
                            results = file_paths,
                        }),
                        previewer = conf.file_previewer({}),
                        sorter = conf.generic_sorter({}),
                    })
                    :find()
            end

            -- stylua: ignore
            vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end, { desc = 'Open harpoon window' })
            -- stylua: ignore
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = 'Harpoon [A]dd' })
        end,
    },
}
