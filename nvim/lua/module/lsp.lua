-- [[
-- FROM https://github.com/neovim/neovim/wiki/Following-HEAD
-- LspInstall LspInstallInfo is deprecated.
-- FROM https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
-- Install language server by myself.
-- ]]
_M_LSP = {}

-- local SEP = "/"
local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system")
end

local lspconfig = require 'lspconfig'
local util = require 'lspconfig/util'

local lsp_status = require('lsp-status')
lsp_status.config {
    select_symbol = function(cursor_pos, symbol)
        if symbol.valueRange then
            local value_range = {
                ["start"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
                ["end"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) }
            }

            return require("lsp-status.util").in_range(cursor_pos, value_range)
        end
    end,
    current_function = true
}
lsp_status.register_progress()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false
})

local lsp_on_attach = function(client, bufnr)
    require'module/_lsp-keymap'.setup_lsp_keymaps(client, bufnr)
    lsp_status.on_attach(client)
    require'lsp_signature'.on_attach({
        bind = true,
        handler_opts = { border = "single" },
        doc_lines = 2,
        hint_enable = true,
        hint_prefix = "🌟 ",
        hint_scheme = "String",
        use_lspsaga = false,
        decorator = { "`", "`" },
        floating_window = true,
        zindex = 50,
        hi_parameter = "Search",
        max_height = 12,
        max_width = 120,
        extra_trigger_chars = {}
    })
    require('symbols-outline').setup()
    require('lspkind').init()
end

local make_lsp_client_capabilities = function()
    -- cmp_nvim_lsp take care of snippetSupport and resolveSupport
    -- lsp_status
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
    return capabilities
end

-- lsp capabilities
local capabilities = make_lsp_client_capabilities()

-- [[
-- npm i -g typescript-language-server typescript
-- npm i -g vim-language-server
-- npm i -g bash-language-server
-- npm i -g vscode-json-languageserver
-- npm i -g yaml-language-server
-- npm i -g vscode-html-languageserver-bin
-- yarn global add diagnostic-languageserver
-- npm i -g sql-language-server
-- npm i -g vls
-- ]]
local servers = { "yamlls", "html", "cmake", "dockerls", "tsserver", "vimls", "bashls", "kotlin_language_server" }

for _, name in pairs(servers) do
    lspconfig[name].setup { on_attach = lsp_on_attach, capabilities = capabilities }
end

lspconfig.vuels.setup {
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    settings = { vetur = { experimental = { templateInterpolationService = true } } }
}

lspconfig.jsonls.setup {
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), vim.fn.strwidth(vim.fn.getline("$")) })
            end
        }
    },
    on_attach = lsp_on_attach,
    capabilities = capabilities
}

lspconfig.sqlls.setup { cmd = { "sql-language-server", "up", "--method", "stdio" } }

lspconfig.pyright.setup {
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
                typeCheckingMode = 'basic'
            },
            venvPath = require("os").getenv("HOME") .. "/" .. ".virtualenvs"
        }
    }
}

lspconfig.clangd.setup {
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = { clangdFileStatus = true },
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    cmd = { "clangd", "--background-index", "-j=8" }
}

lspconfig.gopls.setup { on_attach = lsp_on_attach, capabilities = capabilities }

local sumneko_root_path = vim.fn.stdpath('cache') .. '/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local luadev = require("lua-dev").setup({
    lspconfig = {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = runtime_path },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    -- library = vim.api.nvim_get_runtime_file("", true),
                    preloadFileSize = 1024, -- KB
                    checkThirdParty = false,
                    maxPreload = 2000
                },
                telemetry = { enable = false }
            }
        }
    }
})

lspconfig.sumneko_lua.setup(luadev)

lspconfig.solargraph.setup {
    capabilities = capabilities,
    on_attach = lsp_on_attach,
    cmd = { "/usr/local/lib/ruby/gems/3.0.0/bin/solargraph", "stdio" }
}

-- setup rust-tools
capabilities.experimental = {}
capabilities.experimental.hoverActions = true

local opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        runnables = { use_telescope = true },
        debuggables = { use_telescope = true },
        inlay_hints = { show_parameter_hints = true, parameter_hints_prefix = "<-", other_hints_prefix = "=>" },
        hover_actions = {
            -- whether the hover action window gets automatically focused
            auto_focus = true
        },
        crate_graph = {
            -- Backend used for displaying the graph
            -- see: https://graphviz.org/docs/outputs/
            -- default: x11
            backend = "x11",
            -- where to store the output, nil for no output stored (relative
            -- path from pwd)
            -- default: nil
            output = nil,
            -- true for all crates.io and external crates, false only the local
            -- crates
            -- default: true
            full = true
            -- enabled_graphviz_backends = {
            --   "bmp", "cgimage", "canon", "dot", "gv", "xdot", "xdot1.2", "xdot1.4",
            --   "eps", "exr", "fig", "gd", "gd2", "gif", "gtk", "ico", "cmap", "ismap",
            --   "imap", "cmapx", "imap_np", "cmapx_np", "jpg", "jpeg", "jpe", "jp2",
            --   "json", "json0", "dot_json", "xdot_json", "pdf", "pic", "pct", "pict",
            --   "plain", "plain-ext", "png", "pov", "ps", "ps2", "psd", "sgi", "svg",
            --   "svgz", "tga", "tiff", "tif", "tk", "vml", "vmlz", "wbmp", "webp", "xlib",
            --   "x11"
            -- }
        }
    },
    server = { -- setup rust_analyzer
        on_attach = lsp_on_attach,
        capabilities = capabilities
    }
    -- dap = {
    --   adapter = {
    --     type = 'executable',
    --     command = 'lldb-vscode',
    --     name = "rt_lldb"
    --   }
    -- }
}

require('rust-tools').setup(opts)
-- setup rust-tools end
--
_M_LSP.lsp_client_capabilities = capabilities
return _M_LSP
