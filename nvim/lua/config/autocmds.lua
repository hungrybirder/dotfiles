vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = "YankHighlight",
    pattern = { "*" },
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_augroup("nvim_terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
    group = "nvim_terminal",
    pattern = { "*" },
    callback = function()
        vim.keymap.set("t", "<ESC>", "<c-><c-n>", { buffer = true })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = "LSP: Disable hover capability from Ruff",
})
