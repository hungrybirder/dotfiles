" Java specific
nnoremap <silent> <leader>ji :lua require'jdtls'.organize_imports()<CR>
vnoremap <silent> <leader>je :<Esc>lua require('jdtls').extract_variable(true)<CR>
nnoremap <silent> <leader>je :lua require('jdtls').extract_variable()<CR>
vnoremap <silent> <leader>jm :<Esc>lua require('jdtls').extract_method(true)<CR>

" for nvim-dap
nnoremap <silent> <leader>dC :lua require'jdtls'.test_class()<CR>
nnoremap <silent> <leader>dm :lua require'jdtls'.test_nearest_method()<CR>

