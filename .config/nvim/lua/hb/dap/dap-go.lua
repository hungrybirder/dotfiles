require("dap-go").setup({
    dap_configurations = {
        {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
        },
    },
    delve = {
        port = "38697",
    },
})

vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>")
vim.keymap.set("n", "<leader>dlt", "<cmd>lua require('dap-go').debug_last_test()<CR>")
