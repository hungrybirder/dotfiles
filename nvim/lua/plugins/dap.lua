---@diagnostic disable: unused-local
return {

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- java-debug-adapter / java-test 已在 lsp.lua 的 mason 列表和 LazyVim lang.java 扩展里
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {
                    show_stop_reason = false,
                },
            },
            {
                "mfussenegger/nvim-dap-python",
                -- 用 <leader>dP 前缀，避免与下面全局的 <leader>df（frames）/ <leader>ds（scopes）冲突
                keys = {
                    {
                        "<leader>dPm",
                        function()
                            require("dap-python").test_method()
                        end,
                        desc = "Debug Method",
                        ft = "python",
                    },
                    {
                        "<leader>dPc",
                        function()
                            require("dap-python").test_class()
                        end,
                        desc = "Debug Class",
                        ft = "python",
                    },
                    {
                        "<leader>dPs",
                        function()
                            require("dap-python").debug_selection()
                        end,
                        mode = "v",
                        desc = "Debug Selection",
                        ft = "python",
                    },
                },
                config = function()
                    local dap_py = require("dap-python")
                    dap_py.test_runner = "pytest"
                    -- mason 2.x 提供的 debugpy-adapter 可执行文件，不再硬编码 venv 路径
                    dap_py.setup("debugpy-adapter")
                end,
            },
            {
                "leoluz/nvim-dap-go",
                keys = {
                    { "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>", ft = "go" },
                    { "<leader>dlt", "<cmd>lua require('dap-go').debug_last_test()<CR>", ft = "go" },
                },
                opts = {},
            },
            {
                "jbyuki/one-small-step-for-vimkind",
                config = function()
                    local dap = require("dap")
                    dap.configurations.lua = {
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Attach to running Neovim instance",
                            host = function()
                                local value = vim.fn.input("Host [127.0.0.1]: ")
                                if value ~= "" then
                                    return value
                                end
                                return "127.0.0.1"
                            end,
                            port = function()
                                local val = tonumber(vim.fn.input("Port: "))
                                assert(val, "Please provide a port number")
                                return val
                            end,
                        },
                    }
                    dap.adapters.nlua = function(callback, config)
                        ---@diagnostic disable-next-line: undefined-field
                        callback({ type = "server", host = config.host, port = config.port })
                    end
                end,
            },
        },
        config = function()
            -- Dap commands
            local dap_commands = {
                DapToggleBreakpoint = function()
                    require("dap").toggle_breakpoint()
                end,
                DapToggleRepl = function()
                    require("dap").repl.toggle()
                end,
                DapRunLast = function()
                    require("dap").run_last()
                end,
                DapContinue = function()
                    require("dap").continue()
                end,
                DapNext = function()
                    require("dap").step_over()
                end,
                DapStepInto = function()
                    require("dap").step_into()
                end,
                DapStepOut = function()
                    require("dap").step_out()
                end,
                DapClose = function()
                    require("dap").close()
                end,
                DapBreakpoints = function()
                    require("dap").list_breakpoints()
                end,
                DapCondition = function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
            }
            for name, fn in pairs(dap_commands) do
                vim.api.nvim_create_user_command(name, fn, { desc = name })
            end

            vim.keymap.set("n", "<F4>", function()
                require("dap").close()
                require("dapui").close()
            end)
            vim.keymap.set("n", "<F5>", function()
                require("dap").continue()
            end)
            vim.keymap.set("n", "<F10>", function()
                require("dap").step_over()
            end)
            vim.keymap.set("n", "<F11>", function()
                require("dap").step_into()
            end)
            vim.keymap.set("n", "<F12>", function()
                require("dap").step_out()
            end)
            vim.keymap.set("n", "<F9>", function()
                require("dap").toggle_breakpoint()
            end)
            vim.keymap.set("n", "<Leader>dH", function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end)
            vim.keymap.set("n", "<Leader>dr", function()
                require("dap").repl.open()
            end)
            vim.keymap.set("n", "<Leader>dl", function()
                require("dap").run_last()
            end)
            vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
                require("dap.ui.widgets").hover()
            end)
            vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
                require("dap.ui.widgets").preview()
            end)
            vim.keymap.set("n", "<Leader>df", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.frames)
            end)
            vim.keymap.set("n", "<Leader>ds", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.scopes)
            end)

            -- Simple configuration to attach to remote java debug process
            -- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
            local dap = require("dap")
            dap.configurations.java = {
                {
                    type = "java",
                    request = "attach",
                    name = "Debug (Attach) - Remote",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })
            local dap = require("dap")
            local dapui = require("dapui")
            dap.listeners.before.attach["nvim-dap-ui"] = function()
                dapui.open()
            end
            dap.listeners.before.launch["nvim-dap-ui"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["nvim-dap-ui"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["nvim-dap-ui"] = function()
                dapui.close()
            end

            -- Utility functions shared between progress reports for LSP and DAP
            local client_notifs = {}
            local function get_notif_data(client_id, token)
                if not client_notifs[client_id] then
                    client_notifs[client_id] = {}
                end

                if not client_notifs[client_id][token] then
                    client_notifs[client_id][token] = {}
                end

                return client_notifs[client_id][token]
            end

            local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
            local function update_spinner(client_id, token)
                local notif_data = get_notif_data(client_id, token)

                if notif_data.spinner then
                    local new_spinner = (notif_data.spinner + 1) % #spinner_frames
                    notif_data.spinner = new_spinner

                    notif_data.notification = vim.notify("", vim.log.levels.OFF, {
                        hide_from_history = true,
                        icon = spinner_frames[new_spinner],
                        replace = notif_data.notification,
                    })

                    vim.defer_fn(function()
                        update_spinner(client_id, token)
                    end, 100)
                end
            end

            local function format_title(title, client_name)
                return client_name .. (#title > 0 and ": " .. title or "")
            end

            local function format_message(message, percentage)
                return (percentage and percentage .. "%\t" or "") .. (message or "")
            end

            -- DAP integration
            -- Make sure to also have the snippet with the common helper functions in your config!

            dap.listeners.before["event_progressStart"]["progress-notifications"] = function(session, body)
                local notif_data = get_notif_data("dap", body.progressId)

                local message = format_message(body.message, body.percentage)
                notif_data.notification = vim.notify(message, vim.log.levels.INFO, {
                    title = format_title(body.title, session.config.type),
                    icon = spinner_frames[1],
                    timeout = false,
                    hide_from_history = false,
                })

                notif_data.notification.spinner = 2
                update_spinner("dap", body.progressId)
            end

            dap.listeners.before["event_progressUpdate"]["progress-notifications"] = function(session, body)
                local notif_data = get_notif_data("dap", body.progressId)
                notif_data.notification =
                    vim.notify(format_message(body.message, body.percentage), vim.log.levels.INFO, {
                        replace = notif_data.notification,
                        hide_from_history = false,
                    })
            end

            dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(session, body)
                local notif_data = client_notifs["dap"][body.progressId]
                notif_data.notification =
                    vim.notify(body.message and format_message(body.message) or "Complete", vim.log.levels.INFO, {
                        icon = "",
                        replace = notif_data.notification,
                        timeout = 3000,
                    })
                notif_data.spinner = nil
            end

            -- dapui setup
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                expand_lines = true,
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            "breakpoints",
                            "stacks",
                            "watches",
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen.
                    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                render = { indent = 1 },
            })
        end,
    },
}
