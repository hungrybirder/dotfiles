vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true

vim.keymap.set("n", "<left>", "<cmd>lua require('jvim').to_parent()<CR>")
vim.keymap.set("n", "<right>", "<cmd>lua require('jvim').descend()<CR>")
vim.keymap.set("n", "<up>", "<cmd>lua require('jvim').prev_sibling()<CR>")
vim.keymap.set("n", "<down>", "<cmd>lua require('jvim').next_sibling()<CR>")
