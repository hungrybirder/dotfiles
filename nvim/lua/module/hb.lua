-- future init.lua
-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

local remap = vim.api.nvim_set_keymap

-- Y yank until the end of line
-- remap('n', 'Y', 'y$', { noremap = true})

-- tab
remap('n', ']<tab>', '<cmd>tabnext<cr>', { silent = true, noremap = true} )
remap('n', '[<tab>', '<cmd>tabnext<cr>', { silent = true, noremap = true} )


-- colorizer
require'colorizer'.setup()
