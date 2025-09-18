return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- add tsx and treesitter
            vim.list_extend(opts.ensure_installed, {
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "go",
                    "gomod",
                    "gowork",
                    "gosum",
                    "gotmpl",
                    "comment",
                    "sql",
                    "java",
                    "javascript",
                    "json",
                    "jsonc",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "mermaid",
                    "python",
                    "regex",
                    "rust",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "git_config",
                    "gitignore",
                    "gitattributes",
                    "gitcommit",
                    "git_rebase",
                },
            })
        end,
    },
}
