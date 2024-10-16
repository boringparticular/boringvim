return {
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        enabled = require('nixCatsUtils').enableForCategory('general'),
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                enabled = require('nixCatsUtils').enableForCategory('general'),
                -- NOTE: nixCats: nix downloads it with a different file name.
                -- tell lazy about that.
                name = 'luasnip',
                build = require('nixCatsUtils').lazyAdd((function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)()),
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        enabled = require('nixCatsUtils').enableForCategory('extra'),
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
            { 'onsails/lspkind.nvim', enabled = require('nixCatsUtils').enableForCategory('general') },
            { 'saadparwaiz1/cmp_luasnip', enabled = require('nixCatsUtils').enableForCategory('general') },
            { 'hrsh7th/cmp-nvim-lsp', enabled = require('nixCatsUtils').enableForCategory('devtools') },
            { 'hrsh7th/cmp-path', enabled = require('nixCatsUtils').enableForCategory('general') },
            { 'hrsh7th/cmp-cmdline', enabled = require('nixCatsUtils').enableForCategory('general') },
            { 'hrsh7th/cmp-buffer', enabled = require('nixCatsUtils').enableForCategory('general') },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol', enabled = require('nixCatsUtils').enableForCategory('devtools') },
            { 'hrsh7th/cmp-nvim-lsp-signature-help', enabled = require('nixCatsUtils').enableForCategory('devtools') },
            { 'hrsh7th/cmp-nvim-lua', enabled = require('nixCatsUtils').enableForCategory('devtools') },
            { 'ray-x/cmp-treesitter', enabled = require('nixCatsUtils').enableForCategory('devtools') },
        },
        config = function()
            -- See `:help cmp`
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')
            luasnip.config.setup({})

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        menu = {
                            buffer = '[Buffer]',
                            cody = '[cody]',
                            luasnip = '[LuaSnip]',
                            nvim_lsp = '[LSP]',
                            nvim_lua = '[Lua]',
                            supermaven = '[Supermaven]',
                        },
                        mode = 'symbol_text',
                        preset = 'default',
                        symbol_map = { Copilot = '', Supermaven = '' },
                    }),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                experimental = { ghost_text = true },
                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'cody' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lsp_document_symbol' },
                    { name = 'neorg' },
                    { max_item_count = 5, name = 'luasnip' },
                    { name = 'nvim_lua' },
                    { max_item_count = 5, name = 'buffer' },
                    { name = 'treesitter' },
                    { max_item_count = 5, name = 'path' },
                    { name = 'supermaven' },
                    { name = 'conjure' },
                },
                view = {
                    entries = {
                        follow_cursor = true,
                        name = 'custom',
                        selection_order = 'near_cursor',
                    },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
            -- Set configuration for specific filetype.
            --[[ cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' },
                }, {
                    { name = 'buffer' },
                }),
            })
            require('cmp_git').setup() ]]

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    { name = 'cmdline' },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    },
}
