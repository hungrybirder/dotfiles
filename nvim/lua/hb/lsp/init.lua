vim.api.nvim_command("command! -nargs=0 DisableLspDiagnostic :lua vim.diagnostic.disable()<CR>")
vim.api.nvim_command("command! -nargs=0 EnableLspDiagnostic :lua vim.diagnostic.enable()<CR>")

vim.cmd([[
augroup lspsaga_filetypes
  autocmd!
  autocmd FileType LspsagaCodeAction,LspsagaDiagnostic,LspsagaFinder,LspsagaFloaterm,LspsagaHover,LspsagaRename,LspsagaSignatureHelp nnoremap <buffer><nowait><silent> <Esc> <cmd>close!<cr>
augroup END
]])

require("hb/lsp/langservers")
require("hb/lsp/null-ls")
