---packadd + after/plugin
---@type fun(names: string[]|string)
local load_w_after_plugin = require('nixCatsUtils.lzUtils').make_load_with_after({ 'plugin' })

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
        -- dep_of = { 'nvim-cmp' },
        on_plugin = { 'nvim-cmp' },
        load = load_w_after_plugin,
        after = function(_)
            if pcall(require, 'cmp') then
                require('copilot_cmp').setup()
            end
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
                contexts = {
                    empty = {
                        input = function(callback)
                            callback('')
                        end,
                        resolve = function(input)
                            return {
                                content = input,
                                filename = 'prompt',
                                filetype = 'raw',
                            }
                        end,
                    },
                },
                -- NOTE: Doesn't work. it outputs part of the prompt in chat
                callback = function(response)
                    if vim.g.chat_title then
                        chat.save(vim.g.chat_title)
                        return
                    end

                    local prompt = [[
                    Generate chat title in filepath-friendly format for:

                    ```
                    %s
                    ```

                    Output only the title and nothing else in your response.
                    ]]

                    -- use AI to generate prompt title based on first AI response to user question
                    chat.ask(vim.trim(prompt:format(response)), {
                        headless = true, -- disable updating chat buffer and history with this question
                        callback = function(gen_response)
                            local title = gen_response:match('^%s*(.-)%s*$') -- Trim whitespace
                            vim.g.chat_title = title
                            print('Chat title set to: ' .. vim.g.chat_title)
                            chat.save(vim.g.chat_title)
                        end,
                    })
                end,
            })
            vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CopilotChatToggle<CR>', { desc = '[A]I [C]hat' })
            vim.keymap.set({ 'n', 'v' }, '<leader>ccc', '<cmd>CopilotChatToggle<CR>', { desc = '[C]opilot [C]hat' })
            vim.keymap.set('n', '<leader>ae', '<cmd>CopilotChatExplain<CR>', { desc = '[A]I [E]xplain code' })
            vim.keymap.set('n', '<leader>cce', '<cmd>CopilotChatExplain<CR>', { desc = '[C]opilot [C]hat [E]xplain code' })
            vim.keymap.set('n', '<leader>at', '<cmd>CopilotChatTests<CR>', { desc = '[A]I Generate [T]ests' })
            vim.keymap.set('n', '<leader>cct', '<cmd>CopilotChatTests<CR>', { desc = '[C]opilot [C]hat Generate [T]ests' })
            vim.keymap.set('n', '<leader>ar', '<cmd>CopilotChatReview<CR>', { desc = '[A]I [R]eview Code' })
            vim.keymap.set('n', '<leader>ccr', '<cmd>CopilotChatReview<CR>', { desc = '[C]opilot [C]hat [R]eview Code' })
            vim.keymap.set('n', '<leader>cco', '<cmd>CopilotChatOptimize<CR>', { desc = '[C]opilot [C]hat [O]ptimize Code' })
            vim.keymap.set('n', '<leader>ccd', '<cmd>CopilotChatDocs<CR>', { desc = '[C]opilot [C]hat [D]ocument Code' })

            vim.keymap.set('n', '<leader>ccp', function()
                local actions = require('CopilotChat.actions')
                require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
            end, { desc = '[C]opilot [P]rompt actions' })

            local function load_chat_history()
                local telescope = require('telescope.builtin')
                telescope.find_files({
                    prmpt_title = 'Load Copilot Chat History',
                    cwd = chat.config.history_path,
                    attach_mappings = function(prompt_bufnr, map)
                        local action_state = require('telescope.actions.state')
                        local actions = require('telescope.actions')
                        local custom_action = function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            local filename = vim.fn.fnamemodify(selection.value, ':t:r')
                            vim.cmd('CopilotChatLoad ' .. filename)
                            vim.cmd('CopilotChatOpen')
                        end
                        map('i', '<CR>', custom_action)
                        return true
                    end,
                    entry_marker = function(entry)
                        return {
                            value = entry,
                            display = vim.fn.fnamemodify(entry, ':t:r'),
                            ordinal = vim.fn.fnamemodify(entry, ':t:r'),
                            path = entry,
                        }
                    end,
                })
            end

            local function search_chat_history_content()
                local telescope = require('telescope.builtin')
                telescope.live_grep({
                    prompt_title = 'Search Copilot Chat History',
                    cwd = chat.config.history_path,
                    attach_mappings = function(prompt_bufnr, map)
                        local action_state = require('telescope.actions.state')
                        local actions = require('telescope.actions')
                        local custom_action = function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            local filename = vim.fn.fnamemodify(selection.filename, ':t:r')
                            vim.cmd('CopilotChatLoad ' .. filename)
                            vim.cmd('CopilotChatOpen')
                        end
                        map('i', '<CR>', custom_action)
                        return true
                    end,
                })
            end

            vim.keymap.set('n', '<leader>ccl', load_chat_history, { desc = '[C]opilot [C]hat [L]oad history' })
            vim.keymap.set('n', '<leader>ccs', search_chat_history_content, { desc = '[C]opilot [C]hat [S]earch history' })

            vim.keymap.set({ 'n', 'v' }, '<leader>ax', function()
                vim.g.chat_title = nil
                chat.reset()
            end)

            vim.keymap.set({ 'n', 'v' }, '<leader>ax', function()
                vim.g.chat_title = nil
                chat.reset()
            end)
        end,
    },
    load_sg(),
}
