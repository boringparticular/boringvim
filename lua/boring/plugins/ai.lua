local function load_sg()
    local result

    if vim.env.SG_NVIM_DEV then
        result = { dir = '~/projects/sg.nvim' }
    else
        result = { 'sourcegraph/sg.nvim' }
    end

    return vim.tbl_extend('force', result, {
        for_cat = 'ai.cody',
        event = 'InsertEnter',
        keys = {
            -- { '<leader>cc', '<cmd>CodyToggle<CR>', desc = '[C]ody [C]hat' },
        },
        after = function(_)
            require('sg').setup({
                accept_tos = true,
                enable_cody = true,
                download_binaries = false,
                chat = {
                    default_model = 'anthropic/claude-3-5-sonnet-20240620',
                },
            })
            -- vim.keymap.set('n', '<leader>cc', '<cmd>CodyToggle<CR>', { desc = '[C]ody [C]hat' })
        end,
    })
end

return {
    {
        'supermaven-nvim',
        for_cat = 'ai.supermaven',
        event = 'InsertEnter',
        after = function(_)
            require('supermaven').setup({
                disable_keymaps = true,
                disable_inline_completion = true,
            })
        end,
    },
    {
        'codeium.nvim',
        -- NOTE: Why does completion not work if i set it like this?
        for_cat = 'ai.codeium',
        enabled = true,
        after = function(_)
            require('codeium').setup({
                ebable_chat = true,
            })
        end,
    },
    {
        'copilot.lua',
        for_cat = 'ai.copilot',
        cmd = 'Copilot',
        event = 'InsertEnter',
        after = function(_)
            require('copilot').setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                filetypes = {
                    markdown = true,
                },
            })
        end,
    },
    {
        'copilot-cmp',
        for_cat = 'ai.copilot-cmp',
        after = function(_)
            require('copilot_cmp').setup()
        end,
    },
    {
        'CopilotChat.nvim',
        for_cat = 'ai.copilot',
        -- build = require('nixCatsUtils').lazyAdd((function()
        --     if vim.fn.executable('make') == 0 then
        --         return
        --     end
        --     return 'make tiktoken'
        -- end)()),
        after = function(_)
            local chat = require('CopilotChat')
            chat.setup({
                debug = false, -- Enable debugging
                model = 'claude-3.5-sonnet', -- GPT model to use, 'gpt-3.5-turbo', 'gpt-4', or 'gpt-4o'
                temperature = 0.1, -- GPT temperature
                callback = function(response)
                    if vim.g.chat_title then
                        chat.save(vim.g.chat_title)
                        return
                    end

                    local prompt = [[
                    Generate chat title in filepath-friendly format for:

                    %s

                    Output only the title and nothing else in your response.
                    ]]

                    chat.ask(vim.trim(prompt:format(response)), {
                        no_chat = true,
                        callback = function(gen_response)
                            vim.g.chat_title = vim.trim(gen_response)
                            print('Chat title set to: ' .. vim.g.chat_title)
                            chat.save(vim.g.chat_title)
                        end,
                    })
                end,
            })
            vim.keymap.set('n', '<leader>ac', '<cmd>CopilotChatToggle<CR>', { desc = '[A]I [C]hat' })
            vim.keymap.set('n', '<leader>ccc', '<cmd>CopilotChatToggle<CR>', { desc = '[C]opilot [C]hat' })
            vim.keymap.set('n', '<leader>ae', '<cmd>CopilotChatExplain<CR>', { desc = '[A]I [E]xplain code' })
            vim.keymap.set('n', '<leader>cce', '<cmd>CopilotChatExplain<CR>', { desc = '[C]opilot [C]hat [E]xplain code' })
            vim.keymap.set('n', '<leader>at', '<cmd>CopilotChatTests<CR>', { desc = '[A]I Generate [T]ests' })
            vim.keymap.set('n', '<leader>cct', '<cmd>CopilotChatTests<CR>', { desc = '[C]opilot [C]hat Generate [T]ests' })
            vim.keymap.set('n', '<leader>ar', '<cmd>CopilotChatReview<CR>', { desc = '[A]I [R]eview Code' })
            vim.keymap.set('n', '<leader>ccr', '<cmd>CopilotChatReview<CR>', { desc = '[C]opilot [C]hat [R]eview Code' })

            vim.keymap.set('n', '<leader>ccp', function()
                local actions = require('CopilotChat.actions')
                require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
            end, { desc = '[C]opilot [P]rompt actions' })

            -- vim.keymap.set('n', '<leader>ccl', function()
            --     local options = vim.tbl_map(function(file)
            --         return vim.fn.fnamemodify(file, ':t:r')
            --     end, vim.fn.glob(M.config.history_path .. '/*', true, true))
            --
            --     if not vim.tbl_contains(options, 'default') then
            --         table.insert(options, 1, 'default')
            --     end
            --
            --     require('CopilotChat.integrations.telescope').pick(options)
            -- end, { desc = '[C]opilot [L]oad chat' })

            vim.keymap.set({ 'n', 'v' }, '<leader>ax', function()
                vim.g.chat_title = nil
                chat.reset()
            end)
        end,
    },
    load_sg(),
}
