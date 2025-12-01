---packadd + after/plugin
---@type fun(names: string[]|string)
local load_w_after_plugin = require('nixCatsUtils.lzUtils').make_load_with_after({ 'plugin' })

-- NOTE: packadd doesnt load after directories.
-- hence, the above function that you can get from luaUtils that exists to make that easy.

return {
    {
        'lspkind.nvim',
        for_cat = 'general.cmp',
        dep_of = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp_luasnip',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-nvim-lsp',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-path',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-cmdline',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-buffer',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-nvim-lsp-document-symbol',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-nvim-lsp-signature-help',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-nvim-lua',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-treesitter',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'cmp-spell',
        for_cat = 'general.cmp',
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
    },
    {
        'friendly-snippets',
        for_cat = 'general.cmp',
        dep_of = { 'nvim-cmp' },
    },
    {
        'luasnip',
        for_cat = 'general.cmp',
        dep_of = { 'nvim-cmp' },
        after = function(_)
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup({})
            luasnip.add_snippets('elixir', require('boring.snippets.elixir'))
        end,
    },
    {
        'nvim-cmp',
        for_cat = 'general.cmp',
        event = 'DeferredUIEnter',
        -- NOTE: neovim won't source cmp when i use on_require
        -- on_require = { 'cmp' },
        after = function(_)
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

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
                            copilot = '[Copilot]',
                        },
                        mode = 'symbol_text',
                        preset = 'default',
                        symbol_map = {
                            Copilot = '',
                            Supermaven = '',
                            Codeium = '',
                        },
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
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lsp_document_symbol' },
                    { name = 'neorg' },
                    { max_item_count = 5, name = 'luasnip' },
                    { name = 'nvim_lua' },
                    { max_item_count = 5, name = 'buffer' },
                    { name = 'treesitter' },
                    { max_item_count = 5, name = 'path' },
                    {
                        name = 'spell',
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                            preselect_correct_word = true,
                        },
                    },
                    { name = 'supermaven' },
                    { name = 'codeium' },
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
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        (function()
                            local ok, copilotcmp = pcall(require, 'copilot_cmp.comparators')
                            if not ok then
                                return nil
                            end

                            return copilotcmp.prioritize
                        end)(),

                        -- Below is the default comparitor list and order for nvim-cmp
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
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
                    { name = 'nvim_lsp_document_symbol' },
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
