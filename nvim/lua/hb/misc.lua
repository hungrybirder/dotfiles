-- future init.lua
-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

local remap = vim.api.nvim_set_keymap

-- tab
remap('n', ']<tab>', '<cmd>tabnext<cr>', { silent = true, noremap = true })
remap('n', '[<tab>', '<cmd>tabnext<cr>', { silent = true, noremap = true })

-- colorizer
require"colorizer".setup()
vim.notify = require "notify"
vim.notify.setup()

-- bufferline
vim.o.termguicolors = true

require"bufferline".setup {
    options = {
        diagnostics = "nvim_lsp",
        sort_by = "directory",
        numbers = "buffer_id",
        show_buffer_close_icons = false,
        separator_style = "thin",
        offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left" } }
    }
}
remap('n', 'gb', '<cmd>BufferLinePick<CR>', { noremap = true, silent = true })
remap('n', 'H', '<cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
remap('n', 'L', '<cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })

-- neoscroll
require"neoscroll".setup({
    mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing = false, -- easing_function will be used in all scrolling animations with some defaults
    easing_function = function(x)
        return math.pow(x, 2)
    end -- default easing function
})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '8' } }
t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '8' } }
t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '7' } }
t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '7' } }
t['<C-y>'] = { 'scroll', { '-0.10', 'false', '20' } }
t['<C-e>'] = { 'scroll', { '0.10', 'false', '20' } }
t['zt'] = { 'zt', { '7' } }
t['zz'] = { 'zz', { '7' } }
t['zb'] = { 'zb', { '7' } }
require"neoscroll.config".set_mappings(t)

-- nvim-bqf
require"bqf".setup({
    auto_enable = true,
    preview = { win_height = 12, win_vheight = 12, delay_syntax = 80 },
    filter = {
        fzf = { action_for = { ['ctrl-s'] = 'split' } },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' }
    }
})

vim.cmd([[
    hi BqfPreviewBorder guifg=#a0c980 ctermfg=71
    hi link BqfPreviewRange Search
]])

-- symbols-outline
vim.g.symbols_outline = {
    -- right, 25%, disable auto preview
    relative_width = true,
    width = 35,
    auto_preview = false,
    position = 'right'
}

-- zen-mode
require("zen-mode").setup {}
