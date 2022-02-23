setlocal tabstop=4 shiftwidth=4 expandtab smarttab
" noremap <leader>f :Format<CR>

nnoremap <left> :lua require("jvim").to_parent()<CR>
nnoremap <right> :lua require("jvim").descend()<CR>
nnoremap <up> :lua require("jvim").prev_sibling()<CR>
nnoremap <down> :lua require("jvim").next_sibling()<CR>
