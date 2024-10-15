return {
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        enabled = require('nixCatsUtils').enableForCategory('devtools'),
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            {
                'williamboman/mason.nvim',
                -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
                -- because we will be using nix to download things instead.
                enabled = require('nixCatsUtils').lazyAdd(true, false),
                config = true,
            }, -- NOTE: Must be loaded before dependants
            {
                'williamboman/mason-lspconfig.nvim',
                -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
                -- because we will be using nix to download things instead.
                enabled = require('nixCatsUtils').lazyAdd(true, false),
            },
            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
                -- because we will be using nix to download things instead.
                enabled = require('nixCatsUtils').lazyAdd(true, false),
            },

            { 'j-hui/fidget.nvim', opts = {}, enabled = require('nixCatsUtils').enableForCategory('devtools') },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            {
                'folke/lazydev.nvim',
                enabled = require('nixCatsUtils').enableForCategory('devtools'),
                ft = 'lua',
                opts = {
                    library = {
                        -- adds type hints for nixCats global
                        { path = require('nixCats').nixCatsPath .. '/lua', words = { 'nixCats' } },
                    },
                },
            },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

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

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            -- NOTE: nixCats: there is help in nixCats for lsps at `:h nixCats.LSPs` and also `:h nixCats.luaUtils`
            local servers = {}

            servers.guile_ls = {}
            servers.scheme_langserver = {}
            servers.clangd = {}

            if nixCats('go') then
                servers.gopls = {}
                servers.templ = {}
            end

            if nixCats('python') then
                servers.pyright = {}
            end

            if nixCats('webdev') then
                servers.html = {}
                servers.htmx = {}
                servers.svelte = {}
                servers.tailwindcss = {}
                servers.tsserver = {}
            end

            -- NOTE: nixCats: nixd is not available on mason.
            if require('nixCatsUtils').isNixCats then
                servers.nixd = {}
            else
                servers.rnix = {}
                servers.nil_ls = {}
            end
            servers.lua_ls = {
                -- cmd = {...},
                -- filetypes = { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        diagnostics = {
                            globals = { 'nixCats' },
                            disable = { 'missing-fields' },
                        },
                    },
                },
            }

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

    {
        'ray-x/lsp_signature.nvim',
        enabled = false,
        event = 'VeryLazy',
        opts = {},
        config = function(_, opts)
            require('lsp_signature').setup(opts)

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
                        return
                    end
                    require('lsp_signature').on_attach({
                        -- ... setup options here ...
                        bind = true, -- This is mandatory, otherwise border config won't get registered.
                        handler_opts = {
                            border = 'rounded',
                        },
                    }, bufnr)
                end,
            })
        end,
    },
}
