nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>

command! -nargs=0 DapDebugMethod :lua require'dap-python'.test_method()<CR>
command! -nargs=0 DapDebugClass :lua require'dap-python'.test_class()<CR>
command! -nargs=0 DapDebugSelection :lua require'dap-python'.debug_selection()<CR>

nnoremap <silent> <leader>dm :lua require('dap-python').test_method()<CR>
nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
" vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
