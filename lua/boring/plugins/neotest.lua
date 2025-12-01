return {
    { 'neotest-elixir', for_cat = 'languages.elixir', dep_of = 'neotest' },
    { 'neotest-golang', for_cat = 'languages.go', dep_of = 'neotest' },
    {
        'neotest',
        for_cat = 'general.extra',
        -- stylua: ignore
        keys = {
            { '<leader>t', '', desc = '+[T]est' },
            {'<leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Neo[t]est: Run File',},
            {'<leader>tT', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Neo[t]est: Run All [T]est Files',},
            {'<leader>tr', function() require('neotest').run.run() end, desc = 'Neo[t]est: [R]un Nearest',},
            {'<leader>tl', function() require('neotest').run.run_last() end, desc = 'Neo[t]est: Run [L]ast',},
            {'<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Neo[t]est: Toggle Summary',},
            {'<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Neo[t]est: Show [O]utput',},
            {'<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Neo[t]est: Toggle [O]utput Panel',},
            {'<leader>tS', function() require('neotest').run.stop() end, desc = 'Neo[t]est: [S]top',},
            {'<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Neo[t]est: Toggle [W]atch',},
        },
        after = function(_)
            require('neotest').setup({
                status = { virtual_text = true },
                output = { open_on_run = true },
                quickfix = {
                    open = function()
                        require('trouble').open({ mode = 'quickfix', focus = false })
                    end,
                },
                adapters = {
                    require('neotest-elixir'),
                    require('neotest-golang'),
                },
            })
        end,
    },
}
