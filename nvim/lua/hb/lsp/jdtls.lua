local M = {}

function M.setup()
    local on_attach = function(client, bufnr)
        -- using null-ls for formatting...
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        require("jdtls.setup").add_commands()
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("hb/lsp/keymap").setup_lsp_keymaps(client, bufnr)
    end

    local root_markers = { "gradlew", "pom.xml" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    local home = os.getenv("HOME")

    local capabilities = {
        workspace = { configuration = true },
        textDocument = { completion = { completionItem = { snippetSupport = true } } },
    }

    local workspace_folder = home .. "/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local config = { flags = { allow_incremental_sync = true }, capabilities = capabilities, on_attach = on_attach }

    config.settings = {
        -- ['java.format.settings.url'] = home .. "/.config/nvim/language-servers/java-google-formatter.xml",
        -- ['java.format.settings.profile'] = "GoogleStyle",
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
            },
            sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
            codeGeneration = {
                toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
            },
        },
    }

    config.cmd = { "java-lsp", workspace_folder }
    config.on_attach = on_attach
    config.on_init = function(client, _)
        client.notify("workspace/didChangeConfiguration", { settings = config.settings })
    end

    local jar_patterns = {
        -- cd ~/.config
        -- git clone https://github.com/microsoft/java-debug.git && java-debug
        -- ./mvnw clean install
        "/.config/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
        -- cd ~/.config
        -- git clone https://github.com/dgileadi/vscode-java-decompiler.git
        "/.config/vscode-java-decompiler/server/*.jar", -- cd ~/.config
        -- git clone https://github.com/microsoft/vscode-java-test.git && vscode-java-test
        -- npm install
        -- npm run build-plugin
        "/.config/vscode-java-test/server/*.jar",
    }
    local bundles = {}
    for _, jar_pattern in ipairs(jar_patterns) do
        for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
            if not vim.endswith(bundle, "com.microsoft.java.test.runner.jar") then
                table.insert(bundles, bundle)
            end
        end
    end

    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    config.init_options = {
        --
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities,
    }

    -- local jdtls_ui = require 'jdtls.ui'
    -- function jdtls_ui.pick_one_async(items, _, _, cb)
    --     require'lsputil.codeAction'.code_action_handler(nil, items, nil, nil, cb)
    -- end

    -- start server
    require("jdtls").start_or_attach(config)
end

return M
