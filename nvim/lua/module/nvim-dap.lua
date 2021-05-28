vim.g.dap_virtual_text = true

local dap = require('dap')
dap.defaults.fallback.terminal_win_cmd = '5split new'

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
  }
}

vim.api.nvim_command("command! -nargs=0 DapToggleBreakpoint :lua require'dap'.toggle_breakpoint()<CR>")
vim.api.nvim_command("command! -nargs=0 DapToggleRepl :lua require'dap'.repl.toggle()<CR>")
vim.api.nvim_command("command! -nargs=0 DapRunLast :lua require'dap'.run_last()<CR>")
vim.api.nvim_command("command! -nargs=0 DapContinue :lua require'dap'.continue()<CR>")
vim.api.nvim_command("command! -nargs=0 DapNext :lua require'dap'.step_over()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepInto :lua require'dap'.step_into()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepOut :lua require'dap'.step_out()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStop :lua require'dap'.stop()<CR>")
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
