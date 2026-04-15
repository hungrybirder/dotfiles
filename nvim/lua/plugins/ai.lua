return {
    -- {
    --     "sudo-tee/opencode.nvim",
    --     config = function()
    --         require("opencode").setup({})
    --     end,
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         {
    --             "MeanderingProgrammer/render-markdown.nvim",
    --             opts = {
    --                 anti_conceal = { enabled = false },
    --                 file_types = { "markdown", "opencode_output" },
    --             },
    --             ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
    --         },
    --         -- Optional, for file mentions and commands completion
    --         "hrsh7th/nvim-cmp",
    --
    --         -- Optional, for file mentions picker
    --         "nvim-telescope/telescope.nvim",
    --     },
    -- },
    {
        "Exafunction/windsurf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({})
        end,
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        config = true,
        keys = {
            { "<leader>a", nil, desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
        opts = {
            git_repo_cwd = true,
        },
    },
}
