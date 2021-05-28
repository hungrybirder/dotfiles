" pyright 不支持 textDocument/formatting
" 使用ALEFix做formatting
nnoremap <leader>f <cmd>ALEFix<CR>
nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>

command! -nargs=0 DapTestMethod :lua require'dap-python'.test_method()<CR>
command! -nargs=0 DapTestClass :lua require'dap-python'.test_class()<CR>
