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
dap_py.setup('~/.virtualenvs/debugpy/bin/python')
dap_py.test_runner = 'pytest'

if vim.api.nvim_buf_get_option(0, 'filetype') == 'python' then
  vim.api.nvim_command("command! -nargs=0 DapTestMethod :lua require'dap-python'.test_method()<CR>")
  vim.api.nvim_command("command! -nargs=0 DapTestClass :lua require'dap-python'.test_class()<CR>")
end
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
