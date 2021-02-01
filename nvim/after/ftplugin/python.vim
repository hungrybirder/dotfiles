" pyright 不支持 textDocument/formatting
" 使用ALEFix做formatting
nnoremap <leader>cf <cmd>ALEFix<CR>
nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
