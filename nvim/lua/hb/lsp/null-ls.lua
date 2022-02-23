local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
-- local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    debug = false,
    sources = {
        formatting.stylua,
        formatting.remark,
        formatting.shfmt,
        formatting.yapf,
        formatting.trim_whitespace.with({
            disabled_filetypes = { "go" , "c", "cpp"},
        }),

        diagnostics.shellcheck, -- sh
        diagnostics.staticcheck, -- Go
        diagnostics.pylint, -- python
    },
    on_attach = function(client)
        if client.supports_method("textDocument/formatting") then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        end
    end,
})
