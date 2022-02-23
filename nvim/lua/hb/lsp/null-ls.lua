local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting

null_ls.setup({
    debug = false,
    sources = {
        formatting.stylua,
        formatting.remark,
        formatting.shfmt,
        formatting.yapf,
    },
    on_attach = function(client)
        if client.supports_method("textDocument/formatting") then
            -- wrap in an augroup to prevent duplicate autocmds
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        end
    end,
})
