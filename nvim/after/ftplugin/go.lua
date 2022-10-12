-- nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
-- nnoremap <silent> <leader>g :GoDeclsDir<cr>
-- nnoremap <silent> <leader>o :GoDecls<cr>
-- command! -bang A call go#alternate#Switch(<bang>0, 'edit')
-- command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
-- command! -bang AS call go#alternate#Switch(<bang>0, 'split')
-- command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

-- for nvim-dap
-- nnoremap <silent> <leader>dm :lua require('dap-go').debug_test()<CR>

vim.keymap.set("n", "<leader>dm", "<cmd>lua require('dap-go').debug_test()<CR>")

local status, go = pcall(require, "go")
if status then
    go.setup()
end
