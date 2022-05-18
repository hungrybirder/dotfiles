vim.api.nvim_command("command! -nargs=0 DisableLspDiagnostic :lua vim.diagnostic.disable()<CR>")
vim.api.nvim_command("command! -nargs=0 EnableLspDiagnostic :lua vim.diagnostic.enable()<CR>")

require("hb/lsp/langservers")
-- require("hb/lsp/jdtls")
require("hb/lsp/null-ls")
