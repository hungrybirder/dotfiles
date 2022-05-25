-- [[
-- FROM https://github.com/neovim/neovim/wiki/Following-HEAD
-- LspInstall LspInstallInfo is deprecated.
-- FROM https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
-- Install language server by myself.
-- ]]
local lspconfig = require("lspconfig")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
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

local lsp_on_attach = function(client, bufnr)
    -- using null-ls for formatting...
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    require("hb/lsp/keymap").setup_lsp_keymaps(client, bufnr)
    require("lspsaga").init_lsp_saga({ code_action_keys = { quit = "<esc>", exec = "<CR>" } })
    require("lspkind").init({})
    -- require("lsp_signature").on_attach({
    --     bind = true,
    --     handler_opts = { border = "rounded" },
    --     doc_lines = 2,
    --     hint_enable = true,
    --     hint_prefix = "🌟 ",
    --     hint_scheme = "String",
    --     use_lspsaga = false,
    --     floating_window = false,
    --     floating_window_above_cur_line = true,
    --     max_height = 12,
    --     max_width = 120,
    --     fix_pos = false,
    -- })
end

local make_lsp_client_capabilities = function()
    -- cmp_nvim_lsp take care of snippetSupport and resolveSupport
    local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
    lspconfig[name].setup({
        on_attach = lsp_on_attach,
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities,
    })
end

lspconfig.vuels.setup({
    on_attach = lsp_on_attach,
    flags = { debounce_text_changes = 150 },
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
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

lspconfig.sqlls.setup({
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    flags = { debounce_text_changes = 150 },
})

lspconfig.pyright.setup({
    on_attach = lsp_on_attach,
    flags = { debounce_text_changes = 150 },
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
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities_for_clangd,
    cmd = { "clangd", "--background-index", "-j=8" },
})

lspconfig.gopls.setup({
    on_attach = lsp_on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

local sumneko_root_path = vim.fn.stdpath("cache") .. "/lspconfig/sumneko_lua/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local luadev = require("lua-dev").setup({
    lspconfig = {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        flags = { debounce_text_changes = 150 },
        cmd = { sumneko_binary },
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
            },
        },
    },
})

lspconfig.sumneko_lua.setup(luadev)

lspconfig.solargraph.setup({
    capabilities = capabilities,
    on_attach = lsp_on_attach,
    flags = { debounce_text_changes = 150 },
    cmd = { "/usr/local/lib/ruby/gems/3.0.0/bin/solargraph", "stdio" },
})

-- setup rust-tools
capabilities.experimental = {}
capabilities.experimental.hoverActions = true

local opts = {
    server = { -- setup rust_analyzer
        on_attach = lsp_on_attach,
        flags = { debounce_text_changes = 150 },
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
