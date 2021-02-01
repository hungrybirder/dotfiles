" diagnostic-languageserver 不太好用
" 暂时使用 ALE 做 linter 和 fixer
" 使用ALEFix做formatting
nnoremap <leader>cf <cmd>ALEFix<CR>

nmap <silent> ]d <Plug>(ale_next_wrap)
nmap <silent> [d <Plug>(ale_previous_wrap)

