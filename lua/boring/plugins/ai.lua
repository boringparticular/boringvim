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
    load_sg(),
}
