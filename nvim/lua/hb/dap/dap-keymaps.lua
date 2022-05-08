-- Dap commands
vim.api.nvim_command("command! -nargs=0 DapToggleBreakpoint :lua require'dap'.toggle_breakpoint()<CR>")
vim.api.nvim_command("command! -nargs=0 DapToggleRepl :lua require'dap'.repl.toggle()<CR>")
vim.api.nvim_command("command! -nargs=0 DapRunLast :lua require'dap'.run_last()<CR>")
vim.api.nvim_command("command! -nargs=0 DapContinue :lua require'dap'.continue()<CR>")
vim.api.nvim_command("command! -nargs=0 DapNext :lua require'dap'.step_over()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepInto :lua require'dap'.step_into()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStepOut :lua require'dap'.step_out()<CR>")
vim.api.nvim_command("command! -nargs=0 DapStop :lua require'dap'.terminate()<CR>")
vim.api.nvim_command(
    "command! -nargs=0 DapCondition :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"
)

-- vim.keymap.set('n', '<c-k>', ':lua require"dap".step_out()<CR>')
-- vim.keymap.set('n', '<c-l>', ':lua require"dap".step_into()<CR>')
-- vim.keymap.set('n', '<c-j>', ':lua require"dap".step_over()<CR>')
-- vim.keymap.set('n', '<c-h>', ':lua require"dap".continue()<CR>')
vim.keymap.set("n", "<F4>", '<cmd>lua require"dap".terminate()<CR>')
vim.keymap.set("n", "<F5>", '<cmd>lua require"dap".continue()<CR>')
vim.keymap.set("n", "<F10>", '<cmd>lua require"dap".step_over()<CR>')
vim.keymap.set("n", "<F11>", '<cmd>lua require"dap".step_into()<CR>')
vim.keymap.set("n", "<F12>", '<cmd>lua require"dap".step_out()<CR>')
vim.keymap.set("n", "<F9>", '<cmd>lua require"dap".toggle_breakpoint()<CR>')
vim.keymap.set("n", "<leader>dh", '<cmd>lua require"dap".toggle_breakpoint()<CR>')
vim.keymap.set("n", "<leader>dH", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- vim.keymap.set('n', '<leader>dl','<cmd>lua require"dap".toggle_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'), true)<CR>')
vim.cmd('command! -nargs=0 DapBreakpoints :lua require"dap".list_breakpoints()')
vim.keymap.set("n", "<leader>dk", ':lua require"dap".up()<CR>')
vim.keymap.set("n", "<leader>dj", ':lua require"dap".down()<CR>')
-- vim.keymap.set('n', '<leader>dc', ':lua require"dap".disconnect({ terminateDebuggee = true });require"dap".close()<CR>')
vim.keymap.set("n", "<leader>dc", '<cmd>lua require"dap".terminate()<CR>')
vim.keymap.set("n", "<leader>dr", '<cmd>lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
vim.keymap.set("n", "<leader>di", '<cmd>lua require"dap.ui.variables".hover()<CR>')
vim.keymap.set("n", "<leader>di", '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')
vim.keymap.set("n", "<leader>d?", '<cmd>lua require"dap.ui.variables".scopes()<CR>')
vim.keymap.set("n", "<leader>de", '<cmd>lua require"dap".set_exception_breakpoints({"all"})<CR>')
vim.keymap.set("n", "<leader>da", '<cmd>lua require"debugHelper".attach()<CR>')
vim.keymap.set("n", "<leader>dA", '<cmd>lua require"debugHelper".attachToRemote()<CR>')
vim.keymap.set("n", "<leader>di", '<cmd>lua require"dap.ui.widgets".hover()<CR>')
vim.keymap.set(
    "n",
    "<leader>d?",
    '<cmd>lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>'
)

-- nvim-telescope/telescope-dap.nvim
require("telescope").load_extension("dap")
vim.keymap.set("n", "<leader>ds", ":Telescope dap frames<CR>")
vim.keymap.set("n", "<leader>db", ":Telescope dap list_breakpoints<CR>")
