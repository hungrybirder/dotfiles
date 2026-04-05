return {
    -- {
    --     "greggh/claude-code.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim", -- Required for git operations
    --     },
    --     config = function()
    --         require("claude-code").setup()
    --     end,
    -- },
    {
        "sudo-tee/opencode.nvim",
        config = function()
            require("opencode").setup({})
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    anti_conceal = { enabled = false },
                    file_types = { "markdown", "opencode_output" },
                },
                ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
            },
            -- Optional, for file mentions and commands completion
            "hrsh7th/nvim-cmp",

            -- Optional, for file mentions picker
            "nvim-telescope/telescope.nvim",
        },
    },
}
