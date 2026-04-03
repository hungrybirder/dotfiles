local util_lsp = require("util.lsp")
-- local make_lsp_client_capabilities = util_lsp.make_lsp_client_capabilities
local lsp_on_attach_post = util_lsp.lsp_on_attach_post

local make_lsp_client_capabilities = function()
    -- cmp_nvim_lsp take care of snippetSupport and resolveSupport
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.foldingRange = { -- for nvim-ufo
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    return capabilities
end

return {
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = {
                -- LSP
                "rust-analyzer",
                "pyright",
                "ruff",
                "gopls",
                "golangci-lint-langserver",
                "vim-language-server",
                "bash-language-server",
                "lua-language-server",
                "yaml-language-server",
                "tailwindcss-language-server",
                "typescript-language-server",
                "css-lsp",
                "html-lsp",
                "jdtls",
                "clangd",
                "cmake-language-server",
                "dockerfile-language-server",
                "json-lsp",
                "taplo",

                -- DAP
                "codelldb",
                "debugpy",
                "delve",
                "java-debug-adapter",
                "java-test",
                "vscode-java-decompiler",

                -- Linter
                "ansible-lint",
                "buf", -- linter, formatter, LSP
                "golangci-lint",
                "luacheck",
                "selene", -- lua linter
                "pylint",
                "ruff",
                "shellcheck",
                "staticcheck",
                -- "vale", -- for markdown, https://vale.sh

                -- Formater
                "clang-format",
                "prettier",
                "remark-cli",
                "shfmt",
                "sql-formatter",
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
        opts = {
            -- progress = {
            --     suppress_on_insert = true,
            --     ignore_done_already = true,
            --     ignore_empty_message = true,
        },
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
    -- {
    --     "felpafel/inlay-hint.nvim",
    --     event = "LspAttach",
    --     config = function()
    --         require("inlay-hint").setup({
    --             virt_text_pos = "inline",
    --         })
    --         vim.lsp.inlay_hint.enable(true)
    --     end,
    -- },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("lua_ls", {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if
                            path ~= vim.fn.stdpath("config")
                            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                        then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most
                            -- likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                            -- Tell the language server how to find Lua modules same way as Neovim
                            -- (see `:h lua-module-load`)
                            path = {
                                "lua/?.lua",
                                "lua/?/init.lua",
                            },
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- Depending on the usage, you might want to add additional paths
                                -- here.
                                -- '${3rd}/luv/library',
                                -- '${3rd}/busted/library',
                            },
                            -- Or pull in all of 'runtimepath'.
                            -- NOTE: this is a lot slower and will cause issues when working on
                            -- your own configuration.
                            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                            -- library = vim.api.nvim_get_runtime_file('', true),
                        },
                    })
                end,
                settings = {
                    Lua = {
                        codeLens = {
                            enable = true,
                        },
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                            workspaceDelay = 5000,
                        },
                        workspace = {
                            preloadFileSize = 1024, -- KB
                            checkThirdParty = false,
                            maxPreload = 2000,
                        },
                        telemetry = { enable = false },
                        completion = {
                            callSnippet = "Replace",
                        },
                        hint = {
                            enable = true,
                            setType = false,
                            paramType = true,
                            paramName = "Disable",
                            semicolon = "Disable",
                            arrayIndex = "Disable",
                        },
                        doc = {
                            privateName = { "^_" },
                        },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            vim.lsp.config("gopls", {
                capabilities = make_lsp_client_capabilities(),
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
            })
            vim.lsp.enable("gopls")

            vim.lsp.config("golangci_lint_ls", {
                cmd = { "golangci-lint-langserver" },
                root_markers = { ".git", "go.mod" },
                init_options = {
                    command = {
                        "golangci-lint",
                        "run",
                        "--output.json.path",
                        "stdout",
                        "--show-stats=false",
                        "--issues-exit-code=1",
                    },
                },
            })
            vim.lsp.enable("golangci_lint_ls")

            -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
            local clangd_cap = make_lsp_client_capabilities()
            clangd_cap.offsetEncoding = { "utf-16" }
            -- lspconfig.clangd.setup({
            vim.lsp.config("clangd", {
                init_options = { clangdFileStatus = true },
                capabilities = clangd_cap,
                cmd = { "clangd", "--background-index" },
                filetypes = { "c", "cpp" },
            })
            vim.lsp.enable("clangd")

            -- yaml
            vim.lsp.config("yamlls", {
                capabilities = make_lsp_client_capabilities(),
                settings = {
                    yaml = {
                        hover = true,
                        format = {
                            enable = true,
                            singleQuote = true,
                        },
                        completion = true,
                        validate = true,
                        schemas = {
                            'https://raw.githubusercontent.com/awslabs/goformation/v4.18.2/schema/cloudformation.schema.json: "/*"',
                        },
                        schemaStore = {
                            enable = true,
                        },
                    },
                },
            })
            vim.lsp.enable("yamlls")

            -- python (ruff & pyright)
            local ruff_caps = make_lsp_client_capabilities()
            ruff_caps.general = {
                positionEncodings = { "utf-16" },
            }
            vim.lsp.config("ruff", {
                capabilities = ruff_caps,
            })
            vim.lsp.enable("ruff")

            -- python (ruff & pyright)
            vim.lsp.config("pyright", {
                capabilities = make_lsp_client_capabilities(),
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
                        venvPath = require("os").getenv("HOME") .. "/" .. ".virtualenvs",
                    },
                },
            })
            vim.lsp.enable("pyright")

            local servers = {
                "cmake",
                "dockerls",
                "vimls",
                "bashls",
                "kotlin_language_server",
                "texlab",
                "buf_ls",
                "ansiblels",
                "html",
                "tailwindcss",
                "cssls",
                "taplo",
            }

            for _, name in pairs(servers) do
                vim.lsp.config(name, {
                    capabilities = make_lsp_client_capabilities(),
                })
            end

            vim.lsp.config("ts_ls", {
                capabilities = make_lsp_client_capabilities(),
                single_file_support = false,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literal",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
            })
            vim.lsp.enable("ts_ls")

            -- vue
            vim.lsp.config("vuels", {
                capabilities = make_lsp_client_capabilities(),
                settings = { vetur = { experimental = { templateInterpolationService = true } } },
            })
            vim.lsp.enable("vuels")

            --json
            vim.lsp.config("jsonls", {
                capabilities = make_lsp_client_capabilities(),
                commands = {
                    Format = {
                        function()
                            vim.lsp.buf.range_formatting(
                                {},
                                { 0, 0 },
                                { vim.fn.line("$"), vim.fn.strwidth(vim.fn.getline("$")) }
                            )
                        end,
                    },
                },
            })
            vim.lsp.enable("jsonls")

            -- sql
            vim.lsp.config("sqlls", {
                cmd = { "sql-language-server", "up", "--method", "stdio" },
            })
            vim.lsp.enable("sqlls")

            -- ruby
            vim.lsp.config("solargraph", {
                capabilities = make_lsp_client_capabilities(),
            })
            vim.lsp.enable("solargraph")

            -- rust
            local rust_cap = make_lsp_client_capabilities()
            rust_cap.experimental = {}
            rust_cap.experimental.hoverActions = true

            local opts = {
                server = {
                    on_attach = function(client, bufnr)
                        local rt = require("rust-tools")
                        -- Hover actions
                        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                        -- Code action groups
                        -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                        lsp_on_attach_post(client, bufnr)
                    end,
                    capabilities = rust_cap,
                },
                dap = {
                    adapter = {
                        type = "executable",
                        command = "lldb-vscode",
                        name = "rt_lldb",
                    },
                },
            }

            require("rust-tools").setup(opts)
        end,
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

    -- formatter
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                markdown = { "remark" },
                bash = { "shfmt" },
                go = { "goimports", "gofumpt" },
                python = { "ruff_format" },
                -- toml = { "taplo" },
            },
        },
        event = { "BufWritePre" },
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
                yaml = { "yamllint" },
                -- python = { "ruff" },
            },
        },
    },
}
