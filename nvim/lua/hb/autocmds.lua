vim.opt.laststatus = 3

vim.api.nvim_create_augroup("codelens", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = "codelens",
    pattern = { "*.java" },
    callback = function()
        vim.lsp.codelens.refresh()
    end,
})

vim.api.nvim_create_augroup("jdtls_lsp", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = "jdtls_lsp",
    pattern = { "java" },
    callback = function()
        require("hb/lsp/langservers").setup_jdtls()
    end,
})

vim.api.nvim_create_augroup("bufcheck", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = "bufcheck",
    pattern = vim.env.MYVIMRC,
    command = "silent source %",
})

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

-- Return to last edit position when opening files, feedkeys zz centers the buffer, I wonder if there is a better way
-- augroup last_cursor_position
--   au!
--   au BufReadPost *
--     \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
--     \   execute 'normal! g`"zvzz' |
--     \ endif
-- augroup END

-- vim.api.nvim_create_autocmd("BufReadPost", {
--     group = "bufcheck",
--     pattern = "*",
--     callback = function()
--         local ft = vim.opt_local.filetype:get()
--         if ft:match("commit") or ft:match("rebase") or ft:match("fugitive") then
--             return
--         end
--         local markpos = vim.api.nvim_buf_get_mark(0, '"')
--         local line = markpos[1]
--         local col = markpos[2]
--         if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
--             vim.api.nvim_win_set_cursor(0, { line, col })
--             vim.api.nvim_feedkeys("zvzz", "n", true)
--         end
--     end,
-- })
