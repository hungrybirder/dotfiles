vim.keymap.set("n", "<A-o>", "<cmd>lua require('jdtls').organize_imports()<CR>")
vim.keymap.set("v", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<CR>")
vim.keymap.set("n", "crv", "<cmd>lua require('jdtls').extract_variable()<CR>")
vim.keymap.set("v", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<CR>")
vim.keymap.set("n", "crc", "<cmd>lua require('jdtls').extract_constant()<CR>")
vim.keymap.set("v", "crm", "<esc><cmd>lua require('jdtls').extract_method(true)<CR>")

-- dap
vim.keymap.set("n", "<leader>dC", "<cmd>lua require'jdtls'.test_class()<CR>")
vim.keymap.set("n", "<leader>dm", "<cmd>lua require'jdtls'.test_nearest_method()<CR>")
