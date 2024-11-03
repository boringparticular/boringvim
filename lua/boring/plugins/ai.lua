local function load_sg()
    local result

    if vim.env.SG_NVIM_DEV then
        result = { dir = '~/projects/sg.nvim' }
    else
        result = { 'sourcegraph/sg.nvim' }
    end

    return vim.tbl_extend('force', result, {
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = 'InsertEnter',
        keys = {
            { '<leader>cc', '<cmd>CodyToggle<CR>', desc = '[C]ody [C]hat' },
        },
        opts = {
            accept_tos = true,
            enable_cody = true,
            download_binaries = false,
            chat = {
                default_model = 'anthropic/claude-3-5-sonnet-20240620',
            },
        },
        config = function(_, opts)
            require('sg').setup(opts)
            vim.keymap.set('n', '<leader>cc', '<cmd>CodyToggle<CR>', { desc = '[C]ody [C]hat' })
        end,
    })
end

return {
    {
        'supermaven-inc/supermaven-nvim',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        event = 'InsertEnter',
        opts = {
            disable_keymaps = true,
            disable_inline_completion = true,
        },
    },
    {
        'Exafunction/codeium.nvim',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require('codeium').setup({
                ebable_chat = true,
            })
        end,
    },
    {
        'zbirenbaum/copilot.lua',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        'zbirenbaum/copilot-cmp',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        config = function()
            require('copilot_cmp').setup()
        end,
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        branch = 'canary',
        dependencies = {
            { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
            { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
        },
        build = require('nixCatsUtils').lazyAdd((function()
            if vim.fn.executable('make') == 0 then
                return
            end
            return 'make tiktoken'
        end)()),
        opts = {
            debug = false, -- Enable debugging
            model = 'claude-3.5-sonnet', -- GPT model to use, 'gpt-3.5-turbo', 'gpt-4', or 'gpt-4o'
            temperature = 0.1, -- GPT temperature
        },
        config = function(_, opts)
            require('CopilotChat').setup(opts)
            vim.keymap.set('n', '<leader>tg', '<cmd>CopilotChat<CR>', { desc = '[T]oggle [G]itHub Copilot' })
        end,
        -- See Commands section for default commands if you want to lazy load on them
    },
    load_sg(),
}
