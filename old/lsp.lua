return {
    {
        'nvim-lspconfig',
        for_cat = 'general.lsp',
        event = 'FileType',
        after = function(_)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>cs', vim.lsp.buf.signature_help, '[C]ode [S]ignature Help')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
                            end,
                        })
                    end

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            local servers = {}

            if nixCats('webdev') then
                servers.tailwindcss = {
                    filetypes = { 'heex' },
                }
            end

            -- NOTE: nixCats: nixd is not available on mason.
            if require('nixCatsUtils').isNixCats then
                servers.nixd = {}
            else
                servers.rnix = {}
                servers.nil_ls = {}
            end

            -- NOTE: nixCats: if nix, use lspconfig instead of mason
            -- You could MAKE it work, using lspsAndRuntimeDeps and sharedLibraries in nixCats
            -- but don't... its not worth it. Just add the lsp to lspsAndRuntimeDeps.
            if require('nixCatsUtils').isNixCats then
                for server_name, _ in pairs(servers) do
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        cmd = (servers[server_name] or {}).cmd,
                        root_pattern = (servers[server_name] or {}).root_pattern,
                    })
                end
            else
                -- NOTE: nixCats: and if no nix, do it the normal way

                -- Ensure the servers and tools above are installed
                --  To check the current status of installed tools and/or manually install
                --  other tools, you can run
                --    :Mason
                --
                --  You can press `g?` for help in this menu.
                require('mason').setup()

                -- You can add other tools here that you want Mason to install
                -- for you, so that they are available from within Neovim.
                local ensure_installed = vim.tbl_keys(servers or {})
                vim.list_extend(ensure_installed, {
                    'stylua', -- Used to format Lua code
                })
                require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

                require('mason-lspconfig').setup({
                    handlers = {
                        function(server_name)
                            local server = servers[server_name] or {}
                            -- This handles overriding only values explicitly passed
                            -- by the server configuration above. Useful when disabling
                            -- certain features of an LSP (for example, turning off formatting for tsserver)
                            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                            require('lspconfig')[server_name].setup(server)
                        end,
                    },
                })
            end
        end,
    },
}
