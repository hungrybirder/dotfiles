vim.opt.laststatus = 3

fn = vim.fn

vim.api.nvim_create_augroup("bufcheck", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = "bufcheck",
    pattern = vim.env.MYVIMRC,
    command = "silent source %",
})

-- Return to last edit position when opening files, feedkeys zz centers the buffer, I wonder if there is a better way
-- augroup last_cursor_position
--   au!
--   au BufReadPost *
--     \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
--     \   execute 'normal! g`"zvzz' |
--     \ endif
-- augroup END

vim.api.nvim_create_autocmd("BufReadPost", {
    group = "bufcheck",
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "gitcommit" then
            return
        end
        if vim.bo.filetype == "fugitive" then
            return
        end
        if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
            fn.setpos(".", fn.getpos("'\""))
            vim.api.nvim_feedkeys("zvzz", "n", true)
        end
    end,
})
