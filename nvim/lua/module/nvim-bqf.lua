require('bqf').setup({
    auto_enable = true,
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
    },
    filter = {fzf = {extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}}}
})

vim.api.nvim_exec([[
  hi BqfPreviewBorder guifg=#45a14f ctermfg=71
  hi link BqfPreviewRange Search
]], false)

