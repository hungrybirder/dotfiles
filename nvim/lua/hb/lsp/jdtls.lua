local M = {}

function M.setup()
    local on_attach = function(client, bufnr)
        -- using null-ls for formatting...
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        require("hb/lsp/keymap").setup_lsp_keymaps(client, bufnr)
        require("lspsaga").init_lsp_saga({ code_action_keys = { quit = "<esc>", exec = "<CR>" } })
        require("lspkind").init({})

        require("jdtls.setup").add_commands()
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
        vim.lsp.codelens.refresh()
    end

    local root_markers = { "gradlew", "pom.xml" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    local home = os.getenv("HOME")

    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    extendedClientCapabilities.workspace = { configuration = true }
    extendedClientCapabilities.textDocument = { completion = { completionItem = { snippetSupport = true } } }

    local workspace_folder = home .. "/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
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

    config.cmd = { "java-lsp", workspace_folder }
    config.on_attach = on_attach
    config.on_init = function(client, _)
        client.notify("workspace/didChangeConfiguration", { settings = config.settings })
    end

    -- local jar_patterns = {
    --     -- cd ~/.config
    --     -- git clone https://github.com/microsoft/java-debug.git && java-debug
    --     -- ./mvnw clean install
    --     "/.config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
    --     -- cd ~/.config
    --     -- git clone https://github.com/dgileadi/vscode-java-decompiler.git
    --     "/.config/vscode-java-decompiler/server/*.jar", -- cd ~/.config
    --     -- git clone https://github.com/microsoft/vscode-java-test.git && vscode-java-test
    --     -- npm install
    --     -- npm run build-plugin
    --     "/.config/vscode-java-test/server/*.jar",
    -- }

    local bundles = {
        vim.fn.glob(
            home .. "/.config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
        ),
    }

    vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/vscode-java-test/server/*.jar"), "\n"))

    config["init_options"] = {
        bundles = bundles,
    }

    config.init_options = {
        bundles = bundles,
    }

    require("jdtls").start_or_attach(config)
end

return M
