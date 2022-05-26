vim.api.nvim_create_augroup("cargo_toml_lsp", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "Cargo.toml",
    callback = function()
        -- crates.nvim registered code action into null-ls
        vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")

        -- crates.nvim mappings
        vim.keymap.set("n", "<leader>ct", "<cmd>lua require('crates').toggle()<cr>")
        vim.keymap.set("n", "<leader>cr", "<cmd>lua require('crates').reload()<cr>")

        vim.keymap.set("n", "<leader>cv", "<cmd>lua require('crates').show_versions_popup()<cr>")
        vim.keymap.set("n", "<leader>cf", "<cmd>lua require('crates').show_features_popup()<cr>")

        vim.keymap.set("n", "<leader>cu", "<cmd>lua require('crates').update_crate()<cr>")
        vim.keymap.set("v", "<leader>cu", "<cmd>lua require('crates').update_crates()<cr>")
        -- vim.keymap.set("n", "<leader>ca", "<cmd>lua require('crates').update_all_crates()<cr>")
        vim.keymap.set("n", "<leader>cU", "<cmd>lua require('crates').upgrade_crate()<cr>")
        vim.keymap.set("v", "<leader>cU", "<cmd>lua require('crates').upgrade_crates()<cr>")
        vim.keymap.set("n", "<leader>cA", "<cmd>lua require('crates').upgrade_all_crates()<cr>")

        vim.keymap.set("n", "<leader>cH", "<cmd>lua require('crates').open_homepage()<cr>")
        vim.keymap.set("n", "<leader>cR", "<cmd>lua require('crates').open_repository()<cr>")
        vim.keymap.set("n", "<leader>cD", "<cmd>lua require('crates').open_documentation()<cr>")
        vim.keymap.set("n", "<leader>cC", "<cmd>lua require('crates').open_crates_io()<cr>")
    end,
})
