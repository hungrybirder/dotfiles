local util_lsp = require("util.lsp")
local make_lsp_client_capabilities = util_lsp.make_lsp_client_capabilities
local lsp_on_attach = util_lsp.lsp_on_attach

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
                "vim-language-server",
                "bash-language-server",
                "lua-language-server",
                "yaml-language-server",
                "tailwindcss-language-server",
                "typescript-language-server",
                "css-lsp",
                "html-lsp",
                "jdtls",
                "lombok-nightly",
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
            registries = {
                "github:nvim-java/mason-registry",
                "github:mason-org/mason-registry",
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
    {
        "felpafel/inlay-hint.nvim",
        event = "LspAttach",
        config = function()
            require("inlay-hint").setup({
                virt_text_pos = "inline",
            })
            vim.lsp.inlay_hint.enable(true)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- setup all lsp servers
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                capabilities = make_lsp_client_capabilities(),
                on_attach = lsp_on_attach,
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

            lspconfig.gopls.setup({
                on_attach = lsp_on_attach,
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
                        staticcheck = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                    },
                },
            })

            -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
            local clangd_cap = make_lsp_client_capabilities()
            clangd_cap.offsetEncoding = { "utf-16" }
            lspconfig.clangd.setup({
                init_options = { clangdFileStatus = true },
                on_attach = lsp_on_attach,
                capabilities = clangd_cap,
                cmd = { "clangd", "--background-index" },
                filetypes = { "c", "cpp" },
            })

            -- yaml
            lspconfig.yamlls.setup({
                on_attach = lsp_on_attach,
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

            -- python (ruff & pyright)
            local ruff_caps = make_lsp_client_capabilities()
            ruff_caps.general.positionEncodings = { "utf-16" }
            lspconfig.ruff.setup({
                on_attach = function(client, bufnr)
                    lsp_on_attach(client, bufnr)
                end,
                capabilities = ruff_caps,
            })

            -- python (ruff & pyright)
            lspconfig.pyright.setup({
                on_attach = lsp_on_attach,
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
                lspconfig[name].setup({
                    on_attach = lsp_on_attach,
                    capabilities = make_lsp_client_capabilities(),
                })
            end
            lspconfig.ts_ls.setup({
                on_attach = lsp_on_attach,
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

            -- vue
            lspconfig.vuels.setup({
                on_attach = lsp_on_attach,
                capabilities = make_lsp_client_capabilities(),
                settings = { vetur = { experimental = { templateInterpolationService = true } } },
            })

            --json
            lspconfig.jsonls.setup({
                on_attach = lsp_on_attach,
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

            -- sql
            lspconfig.sqlls.setup({
                cmd = { "sql-language-server", "up", "--method", "stdio" },
            })
            -- ruby
            lspconfig.solargraph.setup({
                capabilities = make_lsp_client_capabilities(),
                on_attach = lsp_on_attach,
            })

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
                        lsp_on_attach(client, bufnr)
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

    -- for Java dev
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "folke/which-key.nvim" },
        ft = { "java" },
        opts = function()
            local mason_registry = require("mason-registry")
            local lombok_jar = mason_registry.get_package("lombok-nightly"):get_install_path() .. "/lombok.jar"
            return {
                -- How to find the root dir for a given filename. The default comes from
                -- lspconfig which provides a function specifically for java projects.
                root_dir = LazyVim.lsp.get_raw_config("jdtls").default_config.root_dir,
                project_name = function(root_dir)
                    return root_dir and vim.fs.basename(root_dir)
                end,
                -- "here are the config and workspace dirs for a project?
                jdtls_config_dir = function(project_name)
                    return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
                end,
                jdtls_workspace_dir = function(project_name)
                    return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
                end,
                -- How to run jdtls. This can be overridden to a full java command-line
                -- if the Python wrapper script doesn't suffice.
                cmd = {
                    vim.fn.exepath("jdtls"),
                    string.format("--jvm-arg=-javaagent:%s", lombok_jar),
                },
                full_cmd = function(opts)
                    local fname = vim.api.nvim_buf_get_name(0)
                    local root_dir = opts.root_dir(fname)
                    local project_name = opts.project_name(root_dir)
                    local cmd = vim.deepcopy(opts.cmd)
                    if project_name then
                        vim.list_extend(cmd, {
                            "-configuration",
                            opts.jdtls_config_dir(project_name),
                            "-data",
                            opts.jdtls_workspace_dir(project_name),
                        })
                    end
                    return cmd
                end,
                -- These depend on nvim-dap, but can additionally be disabled by setting false here.
                dap = { hotcodereplace = "auto", config_overrides = {} },
                dap_main = {},
                test = true,
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        contentProvider = { preferred = "fernflower" },
                        completion = {
                            favoriteStaticMembers = {
                                "org.hamcrest.MatcherAssert.assertThat",
                                "org.hamcrest.Matchers.*",
                                "org.hamcrest.CoreMatchers.*",
                                "org.junit.jupiter.api.Assertions.*",
                                "java.util.Objects.requireNonNull",
                                "java.util.Objects.requireNonNullElse",
                                "org.mockito.Mockito.*",
                            },
                            filteredTypes = {
                                "com.sun.*",
                                "io.micrometer.shaded.*",
                                "java.awt.*",
                                "jdk.*",
                                "sun.*",
                            },
                        },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            },
                            hashCodeEquals = {
                                useJava7Objects = true,
                            },
                            useBlocks = true,
                        },
                        eclipse = {
                            downloadSources = true,
                        },
                        configuration = {
                            updateBuildConfiguration = "interactive",
                        },
                        maven = {
                            downloadSources = true,
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "all",
                            },
                        },
                        implementationsCodeLens = {
                            enabled = true,
                        },
                        references = {
                            includeDecompiledSources = true,
                        },
                        referencesCodeLens = {
                            enabled = true,
                        },
                        flags = {
                            server_side_fuzzy_completion = true,
                        },
                        saveActions = {
                            organizeImports = true,
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local function extend_or_override(config, custom, ...)
                if type(custom) == "function" then
                    config = custom(config, ...) or config
                elseif custom then
                    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
                end
                return config
            end

            -- Find the extra bundles that should be passed on the jdtls command-line
            -- if nvim-dap is enabled with java debug/test.
            local mason_registry = require("mason-registry")
            local bundles = {} ---@type string[]
            if opts.dap and LazyVim.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
                local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
                local java_dbg_path = java_dbg_pkg:get_install_path()
                local jar_patterns = {
                    java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
                }
                -- java-test also depends on java-debug-adapter.
                if opts.test and mason_registry.is_installed("java-test") then
                    local java_test_pkg = mason_registry.get_package("java-test")
                    local java_test_path = java_test_pkg:get_install_path()
                    vim.list_extend(jar_patterns, {
                        java_test_path .. "/extension/server/*.jar",
                    })
                end
                for _, jar_pattern in ipairs(jar_patterns) do
                    for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
                        table.insert(bundles, bundle)
                    end
                end
            end
            local function attach_jdtls()
                local fname = vim.api.nvim_buf_get_name(0)

                local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
                extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
                -- Configuration can be augmented and overridden by opts.jdtls
                local config = extend_or_override({
                    cmd = opts.full_cmd(opts),
                    root_dir = opts.root_dir(fname),
                    init_options = {
                        bundles = bundles,
                        extendedClientCapabilities = extendedClientCapabilities,
                    },
                    settings = opts.settings,
                    capabilities = LazyVim.has("cmp-nvim-lsp") and require("cmp_nvim_lsp").default_capabilities()
                        or nil,
                    -- on_attach = lsp_on_attach,
                    on_attach = function(client, bufnr)
                        lsp_on_attach(client, bufnr)
                        -- code lens
                        -- init call
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_augroup("java_codelens", { clear = true })
                        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                            group = "java_codelens",
                            pattern = { "*.java" },
                            callback = function()
                                vim.lsp.codelens.refresh()
                            end,
                        })
                    end,
                }, opts.jdtls)

                -- Existing server will be reused if the root_dir matches.
                require("jdtls").start_or_attach(config)
                -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
            end
            -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
            -- depending on filetype, so this autocmd doesn't run for the first file.
            -- For that, we call directly below.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = java_filetypes,
                callback = attach_jdtls,
            })
            -- Setup keymap and dap after the lsp is fully attached.
            -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
            -- https://neovim.io/doc/user/lsp.html#LspAttach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == "jdtls" then
                        local wk = require("which-key")
                        wk.add({
                            {
                                mode = "n",
                                buffer = args.buf,
                                { "<leader>cx", group = "extract" },
                                { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
                                { "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
                                { "gs", require("jdtls").super_implementation, desc = "Goto Super" },
                                { "gS", require("jdtls.tests").goto_subjects, desc = "Goto Subjects" },
                                { "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
                            },
                        })
                        wk.add({
                            {
                                mode = "v",
                                buffer = args.buf,
                                { "<leader>cx", group = "extract" },
                                {
                                    "<leader>cxm",
                                    [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                                    desc = "Extract Method",
                                },
                                {
                                    "<leader>cxv",
                                    [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                                    desc = "Extract Variable",
                                },
                                {
                                    "<leader>cxc",
                                    [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                                    desc = "Extract Constant",
                                },
                            },
                        })

                        if
                            opts.dap
                            and LazyVim.has("nvim-dap")
                            and mason_registry.is_installed("java-debug-adapter")
                        then
                            -- custom init for Java debugger
                            require("jdtls").setup_dap(opts.dap)
                            require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)

                            -- Java Test require Java debugger to work
                            if opts.test and mason_registry.is_installed("java-test") then
                                -- custom keymaps for Java test runner (not yet compatible with neotest)
                                wk.add({
                                    {
                                        mode = "n",
                                        buffer = args.buf,
                                        { "<leader>t", group = "test" },
                                        {
                                            "<leader>tt",
                                            function()
                                                require("jdtls.dap").test_class({
                                                    config_overrides = type(opts.test) ~= "boolean"
                                                            and opts.test.config_overrides
                                                        or nil,
                                                })
                                            end,
                                            desc = "Run All Test",
                                        },
                                        {
                                            "<leader>tr",
                                            function()
                                                require("jdtls.dap").test_nearest_method({
                                                    config_overrides = type(opts.test) ~= "boolean"
                                                            and opts.test.config_overrides
                                                        or nil,
                                                })
                                            end,
                                            desc = "Run Nearest Test",
                                        },
                                        { "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test" },
                                    },
                                })
                            end
                        end

                        -- User can set additional keymaps in opts.on_attach
                        if opts.on_attach then
                            opts.on_attach(args)
                        end
                    end
                end,
            })

            -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
            attach_jdtls()
        end,
    },
    -- {
    --     "mfussenegger/nvim-jdtls",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --     },
    --     keys = {
    --         {
    --             "<leader>df",
    --             function()
    --                 require("jdtls").test_class()
    --             end,
    --             ft = "java",
    --             desc = "Java test class",
    --         },
    --         {
    --             "<leader>dn",
    --             function()
    --                 require("jdtls").test_nearest_method()
    --             end,
    --             ft = "java",
    --             desc = "Java test nearest method",
    --         },
    --     },
    --     config = function(_, opts)
    --         vim.api.nvim_create_augroup("codelens", { clear = true })
    --         vim.api.nvim_create_autocmd({ "Buf"ritePost" }, {
    --             group = "codelens",
    --             pattern = { "*.java" },
    --             callback = function()
    --                 vim.lsp.codelens.refresh()
    --             end,
    --         })
    --
    --         vim.api.nvim_create_augroup("jdtls_lsp", { clear = true })
    --         vim.api.nvim_create_autocmd({ "FileType" }, {
    --             group = "jdtls_lsp",
    --             pattern = { "*.java" },
    --             callback = function()
    --                 require("util.lsp").setup_jdtls()
    --             end,
    --         })
    --         -- TODO: LspAttach set dap
    --     end,
    -- },

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
                go = { "golangcilint" },
                lua = { "selene" },
                yaml = { "yamllint" },
                -- python = { "ruff" },
            },
        },
    },
}
