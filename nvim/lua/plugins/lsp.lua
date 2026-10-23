return {
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                -- LSP
                "pyright",
                "ruff",
                "gopls",
                "golangci-lint-langserver",
                "vim-language-server",
                "bash-language-server",
                "lua-language-server",
                "dockerfile-language-server",
                "json-lsp",
                "taplo",

                -- DAP
                "debugpy",
                "delve",

                -- Linter
                "buf", -- linter, formatter, LSP
                "golangci-lint",
                "luacheck",
                "selene", -- lua linter
                "pylint",
                "shellcheck",
                "staticcheck",

                -- Formater
                "prettier",
                "shfmt",
                "stylua",
            },
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                width = 1.0,
                height = 1.0,
            },
        },
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },

    -- IncRename
    -- {
    --     "smjonas/inc-rename.nvim",
    --     config = function()
    --         require("inc_rename").setup({
    --             input_buffer_type = "dressing",
    --         })
    --     end,
    --     keys = {
    --         { "<leader>rn", ":IncRename " },
    --     },
    -- },

    -- 不要给 nvim-lspconfig 写 config = function()：lazy.nvim 对 config 是整体覆盖，
    -- 会跳过 LazyVim 的 LSP 初始化（诊断样式、vim.lsp.enable、mason-lspconfig、inlay hint）。
    -- 所有 server 放进 opts.servers，LazyVim 会自动 vim.lsp.config + vim.lsp.enable，
    -- capabilities 已由 coding.nvim-cmp 扩展通过 vim.lsp.config("*") 统一注入，不用逐个传。
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- 折叠交给 nvim-ufo
            folds = { enabled = false },
            servers = {
                ["*"] = {
                    -- 这些键在 util/lsp.lua 里有自己的实现（loclist / ufo peek），关掉 LazyVim 的默认版本
                    keys = {
                        { "gd", false },
                        { "gD", false },
                        { "gr", false },
                        { "K", false },
                        { "<leader>ca", false },
                        { "<leader>cc", false },
                        { "<leader>cl", false },
                    },
                },
                -- Neovim 运行时库、vim 全局变量由 LazyVim 自带的 lazydev.nvim 处理，不再手写 on_init
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                workspaceDelay = 5000,
                            },
                            workspace = {
                                preloadFileSize = 1024, -- KB
                                maxPreload = 2000,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                gopls = {
                    filetypes = { "go", "gomod" },
                    settings = {
                        gopls = {
                            analyses = {
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                            },
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = false,
                                parameterNames = false,
                                rangeVariableTypes = true,
                            },
                            usePlaceholders = false,
                            staticcheck = false,
                            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                            semanticTokens = true,
                        },
                    },
                },
                -- nvim-lspconfig 自带的 cmd / init_options 已是 golangci-lint v2 语法并带 v1 回退
                golangci_lint_ls = {},
                -- python (ruff & pyright)，ruff 的 hover 在 config/autocmds.lua 里关闭
                ruff = {
                    capabilities = {
                        general = { positionEncodings = { "utf-16" } },
                    },
                },
                pyright = {
                    settings = {
                        pyright = {
                            -- Using Ruff's import organizer
                            disableOrganizeImports = true,
                        },
                        python = {
                            analysis = {
                                -- Ignore all files for analysis to exclusively use Ruff for linting
                                ignore = { "*" },
                            },
                            venvPath = vim.env.HOME .. "/.virtualenvs",
                        },
                    },
                },
                dockerls = {},
                vimls = {},
                bashls = {},
            },
        },
    },

    -- trouble
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>xr",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

    -- formatter（sh = shfmt 由 LazyVim 默认提供；Neovim 把 .sh/.bash 都识别为 sh，没有 bash 这个 filetype）
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                -- conform 没有内置 remark formatter，用已安装的 prettier
                markdown = { "prettier" },
                go = { "goimports", "gofumpt" },
                python = { "ruff_format" },
            },
        },
    },

    -- linters
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                -- Try golangci-lint-langserver
                -- go = { "golangcilint" },
                --
                lua = { "selene" },
                -- python = { "ruff" },
            },
        },
    },
}
