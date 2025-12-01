return {
    {
        'copilot.lua',
        for_cat = 'ai',
        cmd = 'Copilot',
        event = 'InsertEnter',
        keys = {
            {
                '<leader>ua',
                function()
                    vim.g.ai_completion_enabled = not vim.g.ai_completion_enabled
                    vim.notify('AI Completion ' .. (vim.g.ai_completion_enabled and 'Enabled' or 'Disabled'))
                end,
                desc = 'Toggle AI Completion',
            },
        },
        after = function(_)
            vim.g.ai_completion_enabled = false

            require('copilot').setup({
                suggestion = { enabled = true },
                panel = { enabled = true },
                filetypes = {
                    markdown = true,
                    help = true,
                },
            })
        end,
    },
    {
        'CopilotChat.nvim',
        for_cat = 'ai.chat',
        after = function(_)
            local chat = require('CopilotChat')
            chat.setup({
                debug = false, -- Enable debugging
                -- model = 'claude-3.5-sonnet', -- GPT model to use, 'gpt-3.5-turbo', 'gpt-4', or 'gpt-4o'
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
                callback = function(response, source)
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

                    chat.ask(vim.trim(prompt:format(response)), {
                        headless = true,
                        callback = function(gen_response, gen_source)
                            local title = gen_response:match('^%s*(.-)%s*$') -- Trim whitespace
                            vim.g.chat_title = title
                            print('Chat title set to: ' .. vim.g.chat_title)
                            chat.save(vim.g.chat_title)
                        end,
                    })
                end,
                -- callback = function(response)
                --     if vim.g.chat_title then
                --         chat.save(vim.g.chat_title)
                --         return
                --     end
                --
                --     local prompt = [[
                --     Generate chat title in filepath-friendly format for:
                --
                --     ```
                --     %s
                --     ```
                --
                --     Output only the title and nothing else in your response.
                --     ]]
                --
                --     -- use AI to generate prompt title based on first AI response to user question
                --     chat.ask(vim.trim(prompt:format(response)), {
                --         headless = true, -- disable updating chat buffer and history with this question
                --         callback = function(gen_response)
                --             local title = gen_response:match('^%s*(.-)%s*$') -- Trim whitespace
                --             vim.g.chat_title = title
                --             print('Chat title set to: ' .. vim.g.chat_title)
                --             chat.save(vim.g.chat_title)
                --         end,
                --     })
                -- end,
            })
            vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CopilotChatToggle<CR>', { desc = '[A]I [C]hat' })
            vim.keymap.set('n', '<leader>ae', '<cmd>CopilotChatExplain<CR>', { desc = '[A]I [E]xplain code' })
            vim.keymap.set('n', '<leader>at', '<cmd>CopilotChatTests<CR>', { desc = '[A]I Generate [T]ests' })
            vim.keymap.set('n', '<leader>ar', '<cmd>CopilotChatReview<CR>', { desc = '[A]I [R]eview Code' })
            vim.keymap.set('n', '<leader>ao', '<cmd>CopilotChatOptimize<CR>', { desc = '[A]I [O]ptimize Code' })
            vim.keymap.set('n', '<leader>ad', '<cmd>CopilotChatDocs<CR>', { desc = '[A]I [D]ocument Code' })
            vim.keymap.set('n', '<leader>aq', function()
                vim.ui.input({
                    prompt = 'Quick Chat: ',
                }, function(input)
                    if input ~= '' then
                        require('CopilotChat').ask(input)
                    end
                end)
            end, { desc = '[A]I [Q]uick Chat' })

            vim.keymap.set('n', '<leader>ap', function()
                chat.select_prompt()
            end, { desc = '[A]I [P]rompt actions' })

            local function load_chat_history()
                if vim.fn.isdirectory(chat.config.history_path) == 0 then
                    print('Error: Chat history directory not found: ' .. chat.config.history_path)
                    return
                end

                require('fzf-lua').files({
                    prompt = 'Load Copilot Chat History',
                    cwd = chat.config.history_path,
                    winopts = {
                        title = 'Load Copilot Chat History',
                    },
                    actions = {
                        ['default'] = function(selected)
                            if not selected[1] then
                                print('No chat history selected')
                                return
                            end

                            local filename = vim.fn.fnamemodify(selected[1], ':t:r')
                            vim.cmd('CopilotChatLoad ' .. filename)
                            vim.cmd('CopilotChatOpen')
                        end,
                    },
                    file_icons = false,
                    find_opts = [[-type f -name '*.json']],
                })
            end

            local function search_chat_history_content()
                if vim.fn.isdirectory(chat.config.history_path) == 0 then
                    print('Error: Chat history directory not found: ' .. chat.config.history_path)
                    return
                end

                require('fzf-lua').live_grep_native({
                    cwd = chat.config.history_path,
                    winopts = {
                        title = 'Search Copilot Chat History',
                    },
                    actions = {
                        ['default'] = function(selected)
                            if not selected[1] then
                                print('No match found')
                                return
                            end

                            local entry = selected[1]
                            local parts = vim.split(entry, ':')
                            if #parts < 1 then
                                print('Invalid entry format')
                                return
                            end

                            -- TODO: check if file exists
                            local filename = vim.fn.fnamemodify(parts[1], ':t:r')
                            vim.cmd('CopilotChatLoad ' .. filename)
                            vim.cmd('CopilotChatOpen')
                        end,
                    },
                    grep_opts = '--ignore-case',
                })
            end

            vim.keymap.set('n', '<leader>al', load_chat_history, { desc = '[A]I [L]oad history' })
            vim.keymap.set('n', '<leader>as', search_chat_history_content, { desc = '[A]I [S]earch history' })

            vim.keymap.set({ 'n', 'v' }, '<leader>ax', function()
                vim.g.chat_title = nil
                chat.reset()
            end)
        end,
    },
}
