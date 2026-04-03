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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_post", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        local util_lsp = require("util.lsp")
        util_lsp.lsp_on_attach_post(client, bufnr)
        vim.lsp.inlay_hint.enable(true, nil)
    end,
    desc = "LSP Attach Post",
})

-- from neovim v0.12.0 LspInfo/LspLog/LspRestart are deprecated
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
    desc = "Show LSP Info",
})

vim.api.nvim_create_user_command("LspLog", function(_)
    local state_path = vim.fn.stdpath("state")
    local log_path = vim.fs.joinpath(state_path, "lsp.log")

    vim.cmd(string.format("edit %s", log_path))
end, {
    desc = "Show LSP log",
})

vim.api.nvim_create_user_command("LspRestart", "lsp restart", {
    desc = "Restart LSP",
})
