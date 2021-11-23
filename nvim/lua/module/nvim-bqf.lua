require('bqf').setup({
    auto_enable = true,
    preview = { win_height = 12, win_vheight = 12, delay_syntax = 80 },
    filter = { fzf = { extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' } } }
})

vim.cmd([[
    hi BqfPreviewBorder guifg=#a0c980 ctermfg=71
    hi link BqfPreviewRange Search
]])
