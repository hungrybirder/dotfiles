return {
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
            })
            vim.keymap.set(
                "n",
                "<c-q>",
                '<cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>',
                { desc = "Toggle terminal vertically" }
            )
            vim.keymap.set(
                "i",
                "<c-q>",
                '<ESC><cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>',
                { desc = "Toggle terminal vertically" }
            )
            vim.keymap.set(
                "t",
                "<c-q>",
                "<c-\\><c-n>:ToggleTerm direction=vertical<CR>",
                { desc = "Toggle terminal vertically" }
            )
            vim.keymap.set(
                "n",
                "<leader>T",
                '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>',
                { desc = "Toggle terminal horizontally" }
            )
            vim.keymap.set(
                "t",
                "<leader>T",
                '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>',
                { desc = "Toggle terminal horizontally" }
            )
        end,
    },
    -- tmux
    { "christoomey/vim-tmux-navigator" },
    { "shivamashtikar/tmuxjump.vim" },
}
