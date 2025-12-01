vim.keymap.set('n', 'gd', '<cmd>FzfLua lsp_definitions<CR>', { desc = 'LSP: [G]oto [D]efinition' })
vim.keymap.set('n', 'gD', '<cmd>FzfLua lsp_declarations<CR>', { desc = 'LSP: [G]oto [D]eclaration' })
vim.keymap.set('n', 'gr', '<cmd>FzfLua lsp_references<CR>', { desc = 'LSP: [G]oto [R]eferences' })
vim.keymap.set('n', 'gI', '<cmd>FzfLua lsp_implementations<CR>', { desc = 'LSP: [G]oto [I]mplementations' })
vim.keymap.set('n', '<leader>D', '<cmd>FzfLua lsp_typedefs<CR>', { desc = 'LSP: Type [D]efinitions' })
vim.keymap.set('n', '<leader>ds', '<cmd>FzfLua lsp_document_symbols<CR>', { desc = 'LSP: [D]ocument [S]ymbols' })
vim.keymap.set('n', '<leader>ws', '<cmd>FzfLua lsp_live_workspace_symbols<CR>', { desc = 'LSP: [W]orkspace [S]ymbols' })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>FzfLua lsp_code_actions<CR>', { desc = 'LSP: [C]ode [A]ction' })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('boring-lsp', { clear = true }),
    callback = function(args)
        vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover({ border = 'rounded' })
        end, { buffer = args.buf, desc = 'LSP: Hover' })

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = 'LSP: [T]oggle Inlay [H]ints' })
        end
    end,
})

vim.api.nvim_create_augroup('LspAttach_hlargs', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspAttach_hlargs',
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local caps = client.server_capabilities
        if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            require('hlargs').disable_buf(args.buf)
        end
    end,
})

return {
    {
        'nvim-lspconfig',
        for_cat = 'lsp',
        lsp = function(plugin)
            vim.lsp.config(plugin.name, plugin.lsp or {})
            vim.lsp.enable(plugin.name)
        end,
        before = function(_)
            vim.lsp.config('*', {
                capabilities = {},
            })
        end,
    },
    {
        'lspsaga.nvim',
        for_cat = 'lsp',
        after = function(_)
            require('lspsaga').setup({})
        end,
    },
    {
        'outline.nvim',
        for_cat = 'lsp',
        after = function(_)
            require('outline').setup()
        end,
    },
    {
        'fidget.nvim',
        for_cat = 'lsp',
        after = function(_)
            require('fidget').setup({})
        end,
    },
}
