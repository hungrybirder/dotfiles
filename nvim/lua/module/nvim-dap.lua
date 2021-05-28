vim.g.dap_virtual_text = true

local dap = require('dap')
dap.defaults.fallback.terminal_win_cmd = '5split new'

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


local builders = {
  python = function(cmd)
    local non_modules = {"python", "pipenv", "poetry"}

    local module_index
    if vim.tbl_contains(non_modules, cmd[1]) then
      module_index = 3
    else
      module_index = 1
    end

    local args = vim.list_slice(cmd, module_index + 1)

    return {
      dap = {
        type = "python",
        name = "Ultest Debugger",
        request = "launch",
        module = cmd[module_index],
        args = args,
        justMyCode = false,
      }
    }
  end,
  ["go#gotest"] = function(cmd)
    local args = {}

    for i = 3, #cmd - 1, 1 do
      local arg = cmd[i]
      if vim.startswith(arg, "-") then
        arg = "-test." .. string.sub(arg, 2)
      end
      args[#args + 1] = arg
    end
    return {
      dap = {
        type = "go",
        request = "launch",
        mode = "test",
        program = "${workspaceFolder}",
        dlvToolPath = vim.fn.exepath("dlv"),
        args = args
      },
      parse_result = function(lines)
        return lines[#lines] == "FAIL" and 1 or 0
      end
    }
  end
}
require("ultest").setup({builders = builders})
