" diagnostic-languageserver 不太好用
" 暂时使用 ALE 做 linter 和 fixer
" 使用ALEFix做formatting
" nnoremap <leader>f <cmd>ALEFix<CR>

" nmap <silent> ]d <Plug>(ale_next_wrap)
" nmap <silent> [d <Plug>(ale_previous_wrap)

nnoremap <silent> <space>f :lua vim.lsp.buf.formatting()<CR>
vnoremap <silent> <space>f :lua vim.lsp.buf.range_formatting()<CR>
