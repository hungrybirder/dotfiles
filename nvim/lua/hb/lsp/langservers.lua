-- https://github.com/folke/neodev.nvim#-setup
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})

local lspconfig = require("lspconfig")

local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(on_publish_diagnostics, {
    underline = false,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
})

local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, {
    -- Use location list instead of quickfix list
    loclist = true,
})

local lsp_util = require("vim.lsp.util")
local lsp_log = require("vim.lsp.log")

-- Ref1: Copy From https://github.com/neovim/neovim/pull/17339/files
-- Ref2: https://github.com/neovim/neovim/blob/release-0.9/runtime/lua/vim/lsp/handlers.lua#L378-L423
-- 要时刻关注 neovim location_handler 的实现，避免错误使用 loclist
local function my_location_handler(_, result, ctx, config)
    if result == nil or vim.tbl_isempty(result) then
        local _ = lsp_log.info() and lsp_log.info(ctx.method, "No location found")
        return nil
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)

    if #result == 1 then
        lsp_util.jump_to_location(result[1], client.offset_encoding)
    else
        config = config or {}
        if config.loclist then
            vim.fn.setloclist(0, {}, " ", {
                title = "LSP locations",
                items = lsp_util.locations_to_items(result, client.offset_encoding),
            })
            vim.api.nvim_command("botright lopen")
        elseif config.on_list then
            assert(type(config.on_list) == "function", "on_list is not a function")
            config.on_list({ title = title, items = items })
        else
            vim.fn.setqflist({}, " ", {
                title = "LSP locations",
                items = lsp_util.locations_to_items(result, client.offset_encoding),
            })
            vim.api.nvim_command("botright copen")
        end
    end
end

vim.lsp.handlers["textDocument/declaration"] = vim.lsp.with(my_location_handler, {
    loclist = true,
})
vim.lsp.handlers["textDocument/definition"] = vim.lsp.with(my_location_handler, {
    loclist = true,
})
vim.lsp.handlers["textDocument/typeDefinition"] = vim.lsp.with(my_location_handler, {
    loclist = true,
})
vim.lsp.handlers["textDocument/implementation"] = vim.lsp.with(my_location_handler, {
    loclist = true,
})
-- local on_declaration = vim.lsp.handlers["textDocument/declaration"]
-- local on_definition = vim.lsp.handlers["textDocument/definition"]
-- local on_typeDefinition = vim.lsp.handlers["textDocument/typeDefinition"]
-- local on_implementation = vim.lsp.handlers["textDocument/implementation"]

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

-- if you want to set up formatting on save, you can use this as a callback
local lsp_fmt_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local navic = require("nvim-navic")

local function lsp_on_attach(client, bufnr)
    require("hb/lsp/keymap").setup_lsp_keymaps(client, bufnr)
    require("lspkind").init({})
    -- using null-ls for formatting...
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = lsp_fmt_augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = lsp_fmt_augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })
    end
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

local function make_lsp_client_capabilities()
    -- cmp_nvim_lsp take care of snippetSupport and resolveSupport
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    return capabilities
end

-- lsp capabilities
local capabilities = make_lsp_client_capabilities()

local lsp_flags = {
    debounce_text_changes = 200,
}

local servers = {
    "yamlls",
    "html",
    "cmake",
    "dockerls",
    "tsserver",
    "vimls",
    "bashls",
    "kotlin_language_server",
    "texlab",
}

for _, name in pairs(servers) do
    lspconfig[name].setup({
        on_attach = lsp_on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
    })
end

lspconfig.vuels.setup({
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = { vetur = { experimental = { templateInterpolationService = true } } },
})

lspconfig.jsonls.setup({
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), vim.fn.strwidth(vim.fn.getline("$")) })
            end,
        },
    },
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
})

lspconfig.sqlls.setup({
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    flags = lsp_flags,
})

lspconfig.pyright.setup({
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
            },
            venvPath = require("os").getenv("HOME") .. "/" .. ".virtualenvs",
        },
    },
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
local capabilities_for_clangd = make_lsp_client_capabilities()
capabilities_for_clangd.offsetEncoding = { "utf-16" }
lspconfig.clangd.setup({
    init_options = { clangdFileStatus = true },
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    capabilities = capabilities_for_clangd,
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp" },
})

lspconfig.gopls.setup({
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
        gopls = {
            usePlaceholders = false,
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
        },
    },
})

lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" }, workspaceDelay = 5000 },
            workspace = {
                preloadFileSize = 1024, -- KB
                checkThirdParty = false,
                maxPreload = 2000,
            },
            telemetry = { enable = false },
            completion = {
                -- callSnippet = "Replace",
                -- callSnippet = "Both",
                callSnippet = "Disable",
            },
        },
    },
})

lspconfig.solargraph.setup({
    capabilities = capabilities,
    on_attach = lsp_on_attach,
    flags = lsp_flags,
})

-- setup rust-tools
capabilities.experimental = {}
capabilities.experimental.hoverActions = true

local opts = {
    server = {
        -- on_attach = lsp_on_attach,
        on_attach = function(client, bufnr)
            local rt = require("rust-tools")
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            lsp_on_attach(client, bufnr)
        end,
        flags = lsp_flags,
        capabilities = capabilities,
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
-- setup rust-tools end

-- jdtls
setup_jdtls = function()
    local on_attach = function(client, bufnr)
        -- using null-ls for formatting...
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = lsp_fmt_augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = lsp_fmt_augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting(bufnr)
                end,
            })
        end

        require("hb/lsp/keymap").setup_lsp_keymaps(client, bufnr)
        require("lspkind").init({})

        require("jdtls").setup_dap({
            hotcodereplace = "auto",
            config_overrides = {},
        })
        require("jdtls.dap").setup_dap_main_class_configs()
        vim.lsp.codelens.refresh()
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end
    end

    local root_markers = { "gradlew", "pom.xml" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    local home_dir = os.getenv("HOME")

    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    extendedClientCapabilities.workspace = { configuration = true }
    extendedClientCapabilities.textDocument = { completion = { completionItem = { snippetSupport = true } } }

    local workspace_folder = home_dir .. "/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local config = {
        flags = { allow_incremental_sync = true },
        capabilities = extendedClientCapabilities,
    }

    config.settings = {
        -- ['java.format.settings.url'] = home .. "/.config/nvim/language-servers/java-google-formatter.xml",
        -- ['java.format.settings.profile'] = "GoogleStyle",
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
        },
        signatureHelp = { enabled = true },
        referencesCodeLens = {
            enabled = true,
        },
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
        },
        contentProvider = { preferred = "fernflower" },
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
            useBlocks = true,
        },
    }

    local mason_package_path = vim.fn.stdpath("data") .. "/mason/packages"
    local os_name = "mac"
    if jit.os ~= "OSX" then
        os_name = "linux"
    end
    -- JDT_LS_HOME="/opt/homebrew/Cellar/jdt-language-server/1.26.0-202307200157/libexec"
    -- JDT_LS_LAUNCHER=$(find $JDT_LS_HOME -name "org.eclipse.equinox.launcher_*.jar")
    -- JDT_LS_HEAP_SIZE=${JDT_LS_HEAP_SIZE:=-Xmx12G}
    -- JAVA_BIN="java"
    -- GRADLE_HOME="$(brew --prefix)/opt/gradle"
    -- export GRADLE_HOME
    -- exec $JAVA_BIN   -Declipse.application=org.eclipse.jdt.ls.core.id1
    -- -Dosgi.bundles.defaultStartLevel=4
    -- -Declipse.product=org.eclipse.jdt.ls.core.product
    -- -Dlog.protocol=true
    -- -Dlog.level=ALL
    -- $JDT_LS_HEAP_SIZE
    -- -jar "$JDT_LS_LAUNCHER"
    -- -configuration "$JDT_LS_HOME/config_mac"
    -- -data "$1"
    -- config.cmd = { "java-lsp", workspace_folder }
    config.cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx16g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(mason_package_path .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        vim.fn.glob(mason_package_path .. "/jdtls/config_" .. os_name),
        "-data",
        workspace_folder,
    }
    config.on_attach = on_attach
    config.on_init = function(client, _)
        client.notify("workspace/didChangeConfiguration", { settings = config.settings })
    end

    -- cd ~/.config
    -- git clone https://github.com/microsoft/java-debug.git && java-debug
    -- ./mvnw clean install
    -- "/.config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
    -- cd ~/.config
    -- git clone https://github.com/dgileadi/vscode-java-decompiler.git
    -- "/.config/vscode-java-decompiler/server/*.jar"
    -- cd ~/.config
    -- git clone https://github.com/microsoft/vscode-java-test.git && vscode-java-test
    -- npm install
    -- npm run build-plugin
    -- "/.config/vscode-java-test/server/*.jar",

    local bundles = {
        vim.fn.glob(
            mason_package_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
            true
        ),
    }
    vim.list_extend(
        bundles,
        vim.split(vim.fn.glob(mason_package_path .. "/java-test/extension/server/*.jar", true), "\n")
    )
    config.init_options = {
        bundles = bundles,
    }
    require("jdtls").start_or_attach(config)
end

return {
    setup_jdtls = setup_jdtls,
}
