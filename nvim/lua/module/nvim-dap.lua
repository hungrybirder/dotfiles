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
dap.defaults.fallback.terminal_win_cmd = '5split new'
vim.fn.sign_define('DapBreakpoint', {text='🟥', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

dap.adapters.go = function(callback, config)
    local handle
    local pid_or_err
    local port = 38697
    handle, pid_or_err = vim.loop.spawn("dlv",
      {
        args = {"dap", "-l", "127.0.0.1:" .. port},
        detached = true
      },
      function(code)
        handle:close()
        print("Delve exited with exit code: " .. code)
      end
    )
    -- Wait 100ms for delve to start
    vim.defer_fn(
      function()
        -- dap.repl.open()
        callback({type = "server", host = "127.0.0.1", port = port})
      end, 100)
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug UnitTest",
    mode = "test",
    request = "launch",
    program = "${file}",
  },
}

vim.api.nvim_command("command! -nargs=0 DapToggleBreakpoint :lua require'dap'.toggle_breakpoint()<CR>")
vim.api.nvim_command("command! -nargs=0 DapToggleRepl :lua require'dap'.repl.toggle()<CR>")
vim.api.nvim_command("command! -nargs=0 DapRunLast :lua require'dap'.run_last()<CR>")
vim.api.nvim_command("command! -nargs=0 DapContinue :lua require'dap'.continue()<CR>")
vim.api.nvim_command("command! -nargs=0 DapNext :lua require'dap'.step_over()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepInto :lua require'dap'.step_into()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepOut :lua require'dap'.step_out()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStop :lua require'dap'.close()<CR>")
vim.api.nvim_command("command! -nargs=0 DapCondition :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")


-- TODO widgets
-- local widgets = require('dap.ui.widgets')
-- widgets.sidebar(widgets.scopes).open()
-- widgets.sidebar(widgets.frames).open()

-- for python
local dap_py = require('dap-python')
dap_py.test_runner = 'pytest'
dap_py.setup('~/.virtualenvs/debugpy/bin/python')
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>

-- nvim-dap-ui
require("dapui").setup()
vim.api.nvim_command("command! -nargs=0 DapUIStart :lua require'dapui'.open()<CR> require'dap'.continue()<CR>")
vim.api.nvim_command("command! -nargs=0 DapUIStop :lua require'dapui'.close()<CR> require'dap'.close()<CR>")
