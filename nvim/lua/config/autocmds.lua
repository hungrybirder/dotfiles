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
