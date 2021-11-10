-- require'nvim-dap-virtual-text'.setup()
require("nvim-dap-virtual-text").setup {
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    -- experimental features:
    virt_text_pos = 'eol', -- position of virtual text, see :h nvim_buf_set_extmark()
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80 see :h nvim_buf_set_extmark()
}
local dap = require('dap')
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🟦', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })

-- - Some variables are supported:
--   - ${file}: Active filename
--   - ${fileBasename}: The current file's basename
--   - ${fileBasenameNoExtension}: The current file's basename without extension
--   - ${fileDirname}: The current file's dirname
--   - ${fileExtname}: The current file's extension
--   - ${relativeFile}: The current file relative to getcwd()
--   - ${relativeFileDirname}: The current file's dirname relative to getcwd()
--   - ${workspaceFolder}: The current working directory of Neovim
--   - ${workspaceFolderBasename}: The name of the folder opened in Neovim

dap.adapters.cpp = {
    type = 'executable',
    attach = { pidProperty = "pid", pidSelect = "ask" },
    command = 'lldb-vscode',
    env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
    name = "lldb"
}

dap.configurations.cpp = {
    {
        type = 'cpp',
        name = "Launch",
        request = "launch",
        program = "${workspaceFolder}/${relativeFileDirname}/build/${fileBasenameNoExtension}",
        args = args,
        cwd = vim.fn.getcwd(),
        environment = {},
        externalConsole = true,
        MIMode = mi_mode or "lldb",
        MIDebuggerPath = mi_debugger_path
    }
}

-- dap-go
require('dap-go').setup()

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
        host = function()
            local value = vim.fn.input('Host [127.0.0.1]: ')
            if value ~= "" then
                return value
            end
            return '127.0.0.1'
        end,
        port = function()
            local val = tonumber(vim.fn.input('Port: '))
            assert(val, "Please provide a port number")
            return val
        end
    }
}

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host, port = config.port })
end

-- for python
local dap_py = require('dap-python')
dap_py.test_runner = 'pytest'
dap_py.setup('~/.virtualenvs/debugpy/bin/python')

-- nvim-dap-ui
require("dapui").setup()

-- Dap commands
vim.api.nvim_command("command! -nargs=0 DapToggleBreakpoint :lua require'dap'.toggle_breakpoint()<CR>")
vim.api.nvim_command("command! -nargs=0 DapToggleRepl :lua require'dap'.repl.toggle()<CR>")
vim.api.nvim_command("command! -nargs=0 DapRunLast :lua require'dap'.run_last()<CR>")
vim.api.nvim_command("command! -nargs=0 DapContinue :lua require'dap'.continue()<CR>")
vim.api.nvim_command("command! -nargs=0 DapNext :lua require'dap'.step_over()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepInto :lua require'dap'.step_into()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepOut :lua require'dap'.step_out()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStop :lua require'dap'.close()<CR>")
vim.api.nvim_command(
    "command! -nargs=0 DapCondition :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")

local mapper = function(mode, key, result)
    vim.api.nvim_set_keymap(mode, key, result, { noremap = true, silent = true })
end

-- mapper('n', '<c-k>', ':lua require"dap".step_out()<CR>')
-- mapper('n', '<c-l>', ':lua require"dap".step_into()<CR>')
-- mapper('n', '<c-j>', ':lua require"dap".step_over()<CR>')
-- mapper('n', '<c-h>', ':lua require"dap".continue()<CR>')
mapper('n', '<F4>', '<cmd>lua require"dapui".toggle()<CR>')
mapper('n', '<F5>', '<cmd>lua require"dap".continue()<CR>')
mapper('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>')
mapper('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>')
mapper('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>')
mapper('n', '<F9>', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
mapper('n', '<leader>dh', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
mapper('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- mapper('n', '<leader>dl','<cmd>lua require"dap".toggle_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'), true)<CR>')
mapper('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle({height=15})<CR>')
vim.cmd('command! -nargs=0 DapBreakpoints :lua require"dap".list_breakpoints()')
mapper('n', '<leader>dk', ':lua require"dap".up()<CR>')
mapper('n', '<leader>dj', ':lua require"dap".down()<CR>')
-- mapper('n', '<leader>dc', ':lua require"dap".disconnect({ terminateDebuggee = true });require"dap".close()<CR>')
mapper('n', '<leader>dc', ':lua require"dap".disconnect();require"dap".close()<CR>')
mapper('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
mapper('n', '<leader>di', ':lua require"dap.ui.variables".hover()<CR>')
mapper('n', '<leader>di', ':lua require"dap.ui.variables".visual_hover()<CR>')
mapper('n', '<leader>d?', ':lua require"dap.ui.variables".scopes()<CR>')
mapper('n', '<leader>de', ':lua require"dap".set_exception_breakpoints({"all"})<CR>')
mapper('n', '<leader>da', ':lua require"debugHelper".attach()<CR>')
mapper('n', '<leader>dA', ':lua require"debugHelper".attachToRemote()<CR>')
mapper('n', '<leader>di', ':lua require"dap.ui.widgets".hover()<CR>')
mapper('n', '<leader>d?', ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>')

-- nvim-telescope/telescope-dap.nvim
require('telescope').load_extension('dap')
mapper('n', '<leader>ds', ':Telescope dap frames<CR>')
mapper('n', '<leader>db', ':Telescope dap list_breakpoints<CR>')
