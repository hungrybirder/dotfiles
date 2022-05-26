augroup cargo_toml_lsp
    autocmd!
    autocmd BufEnter Cargo.toml nnoremap <silent> <leader>ca :Lspsaga code_action<CR>
augroup end
