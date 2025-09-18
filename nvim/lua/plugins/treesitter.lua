return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- dependencies = {
        -- "nvim-treesitter/nvim-treesitter-textobjects",
        -- "nvim-treesitter/nvim-treesitter-refactor",
        -- "RRethy/nvim-treesitter-endwise",
        -- "theprimeagen/jvim.nvim", -- for json
        -- },
        opts = {
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
            indent = { enable = false },
            highlight = {
                enable = true,
                -- Disable slow treesitter highlight for large files
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<cr>",
                    node_decremental = "<tab>",
                    scope_incremental = "<s-cr>",
                },
            },
            -- refactor = {
            --     highlight_definitions = { enable = false },
            --     highlight_current_scope = { enable = false },
            --     smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
            --     navigation = {
            --         enable = true,
            --         keymaps = {
            --             goto_definition = "gnd",
            --             list_definitions = "gnD",
            --             list_definitions_toc = "gO",
            --             goto_next_usage = "<a-*>",
            --             goto_previous_usage = "<a-#>",
            --         },
            --     },
            -- },
            -- endwise = { enable = true },
            -- -- nvim-treesitter/nvim-treesitter-textobjects
            -- textobjects = {
            --     select = {
            --         enable = true,
            --         lookahead = true,
            --         keymaps = {
            --             -- You can use the capture groups defined in textobjects.scm
            --             ["ie"] = "@block.inner",
            --             ["ae"] = "@block.outer",
            --             ["im"] = "@call.inner",
            --             ["am"] = "@call.outer",
            --             ["if"] = "@function.inner",
            --             ["af"] = "@function.outer",
            --             ["iC"] = "@class.inner",
            --             ["aC"] = "@class.outer",
            --             ["ic"] = "@conditional.inner",
            --             ["ac"] = "@conditional.outer",
            --             ["il"] = "@loop.inner",
            --             ["al"] = "@loop.outer",
            --             ["is"] = "@parameter.inner",
            --             ["as"] = "@statement.outer",
            --             ["ad"] = "@comment.outer",
            --         },
            --     },
            lsp_interop = {
                enable = true,
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
            move = {
                enable = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>sn"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>sp"] = "@parameter.inner",
                },
            },
        },
        playground = {
            enable = true,
            -- disable = {},
            updatetime = 25,
            persist_queries = false,
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        matchup = { enable = true },
        autopairs = { enable = true },
    },
}
