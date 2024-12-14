return {
    {
        'elixir-tools/elixir-tools.nvim',
        version = '*',
        enabled = require('nixCatsUtils').enableForCategory('elixir'),
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local elixir = require('elixir')
            local elixirls = require('elixir.elixirls')

            elixir.setup({
                nextls = {
                    enable = false,
                    init_options = {
                        mix_env = 'dev',
                        mix_target = 'host',
                        experimental = {
                            completions = {
                                enable = true,
                            },
                        },
                    },
                },

                elixirls = {
                    enable = true,
                    settings = elixirls.settings({
                        dialyzerEnabled = true,
                        enableTestLenses = true,
                        suggestSpecs = true,
                    }),
                    on_attach = function(client, bufnr)
                        vim.keymap.set('n', '<space>fp', ':ElixirFromPipe<cr>', { buffer = true, noremap = true })
                        vim.keymap.set('n', '<space>tp', ':ElixirToPipe<cr>', { buffer = true, noremap = true })
                        vim.keymap.set('v', '<space>em', ':ElixirExpandMacro<cr>', { buffer = true, noremap = true })
                    end,
                },
                projectionist = {
                    enable = true,
                },
            })
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
}
