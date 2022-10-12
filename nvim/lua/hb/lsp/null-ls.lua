local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    debug = false,
    sources = {
        formatting.stylua,
        formatting.remark,
        formatting.shfmt,
        formatting.yapf,
        formatting.trim_whitespace,
        formatting.goimports,
        formatting.gofmt,
        formatting.rustfmt,
        formatting.clang_format.with({
            filetypes = { "c", "cpp" },
        }),
        formatting.sql_formatter,
        -- formatting.google_java_format,

        diagnostics.shellcheck, -- sh
        diagnostics.staticcheck, -- Go
        diagnostics.pylint, -- python

        -- code_actions
        code_actions.gitsigns,
    },
    on_attach = function(client)
        if client.supports_method("textDocument/formatting") then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePost <buffer> lua vim.lsp.buf.format({ async=false })
            augroup END
            ]])
        end
    end,
})
