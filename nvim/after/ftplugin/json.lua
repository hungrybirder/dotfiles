vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true

vim.keympap.set("n", "<left>", "<cmd>lua require("jvim").to_parent()<CR>")
vim.keympap.set("n", "<right>", "<cmd>lua require("jvim").descend()<CR>")
vim.keympap.set("n", "<up>", "<cmd>lua require("jvim").prev_sibling()<CR>")
vim.keympap.set("n", "<down>", "<cmd>lua require("jvim").next_sibling()<CR>")
