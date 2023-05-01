-- Highlight on yank
vim.api.nvim_exec(
    [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
    false
)

-- tab
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "[<tab>", "<cmd>tabnext<cr>")

-- which-key
-- require("which-key").setup({})
--
require("hlslens").setup({ calm_down = true })
vim.cmd([[
    aug VMlens
        au!
        au User visual_multi_start lua require("hb/vmlens").start()
        au User visual_multi_exit lua require("hb/vmlens").exit()
    aug END
]])
local kopts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
    "n",
    "n",
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts
)
vim.api.nvim_set_keymap(
    "n",
    "N",
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts
)
vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
