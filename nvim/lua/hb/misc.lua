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

notify = require("notify")
notify.setup({})
vim.notify = notify

-- which-key
-- require("which-key").setup({})
