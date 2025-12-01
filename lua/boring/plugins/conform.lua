return {
    {
        'conform.nvim',
        for_cat = 'general.extra',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format({ async = true, lsp_fallback = true })
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        after = function(_)
            ---@module "conform"
            ---@type conform.setupOpts
            require('conform').setup({
                formatters = {
                    nasmfmt = {
                        command = 'nasmfmt',
                        stdin = false,
                        args = { '$FILENAME' },
                    },
                },
                notify_on_error = false,
                format_on_save = function(bufnr)
                    -- Disable "format_on_save lsp_fallback" for languages that don't
                    -- have a well standardized coding style. You can add additional
                    -- languages here or re-enable it for the disabled ones.
                    local disable_filetypes = { c = true, cpp = true }
                    return {
                        timeout_ms = 2500,
                        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                    }
                end,
                formatters_by_ft = {
                    lua = { 'stylua' },
                    nix = { 'nixfmt', 'alejandra', stop_after_first = true },
                    python = function(bufnr)
                        if require('conform').get_formatter_info('ruff_format', bufnr).available then
                            return { 'ruff_format' }
                        else
                            return { 'isort', 'black' }
                        end
                    end,
                    html = { 'prettierd', 'prettier', stop_after_first = true },
                    css = { 'prettierd', 'prettier', 'stylelint', stop_after_first = true },
                    javascript = { 'prettierd', 'prettier', stop_after_first = true },
                    typescript = { 'prettierd', 'prettier', stop_after_first = true },
                    svelte = { 'prettierd', 'prettier', stop_after_first = true },
                    json = { 'prettierd', 'prettier', stop_after_first = true },
                    markdown = { 'prettierd', 'prettier', stop_after_first = true },
                    gohtmltmpl = { 'prettierd', 'prettier', stop_after_first = true },
                    go = { 'gofumpt', 'gofmt', stop_after_first = true },
                    templ = { 'templ' },
                    rust = { 'rustfmt', lsp_format = 'fallback' },
                    just = { 'just' },
                    elixir = { 'mix' },
                    heex = { 'mix' },
                    asm = { 'nasmfmt' },
                    zig = { 'zigfmt' },
                    dart = { 'dart_format' },
                    ['*'] = { 'injected' },
                    ['_'] = { 'trim_whitespace' },
                },
            })
        end,
    },
}
