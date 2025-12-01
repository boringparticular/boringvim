return {
    {
        'nvim-lint',
        for_cat = 'general',
        event = { 'BufReadPre', 'BufNewFile' },
        after = function(_)
            local lint = require('lint')
            lint.linters_by_ft = {
                markdown = { 'markdownlint' },
                rst = { 'vale' },
                python = { 'ruff' },
                text = { 'vale' },
                json = { 'jsonlint' },
                go = { 'golangcilint' },
                elixir = { 'credo' },
            }

            local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
                group = lint_augroup,
                callback = function()
                    require('lint').try_lint()
                end,
            })
        end,
    },
}
