local M = {}

function M.show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
        require("crates").show_popup()
    else
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end
end

function M.setup_lsp_hightlight_autocmd(bufnr)
    local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = highlight_augroup,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = highlight_augroup,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
    })
end

function M.lsp_on_attach(client, bufnr)
    require("lspkind").init()
    if client.server_capabilities.documentHighlightProvider then
        M.setup_lsp_hightlight_autocmd(bufnr)
    end
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, {
            bufnr = bufnr,
        })
    end
    M.setup_lsp_keymaps(client, bufnr)
end

function M.make_lsp_client_capabilities()
    -- cmp_nvim_lsp take care of snippetSupport and resolveSupport
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.foldingRange = { -- for nvim-ufo
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    return capabilities
end

-- 设置 lsp handlers
-- 使用 loclist 不使用 quickfix
function M.setup_lsp_handlers()
    local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(on_publish_diagnostics, {
        underline = false,
        -- virtual_text = true,
        virtual_text = false,
        signs = true,
        update_in_insert = false,
    })

    local on_references = vim.lsp.handlers["textDocument/references"]
    vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, {
        -- Use location list instead of quickfix list
        loclist = true,
    })
    local on_document_symbol = vim.lsp.handlers["textDocument/documentSymbol"]
    vim.lsp.handlers["textDocument/documentSymbol"] = vim.lsp.with(on_document_symbol, {
        loclist = true,
    })
    local on_workspace_symbol = vim.lsp.handlers["workspace/symbol"]
    vim.lsp.handlers["workspace/symbol"] = vim.lsp.with(on_workspace_symbol, {
        loclist = true,
    })

    -- Ref1: Copy From https://github.com/neovim/neovim/pull/17339/files
    -- Ref2: runtime/lua/vim/lsp/handlers.lua#L417
    -- 关注 neovim location_handler 的实现，避免错误使用 loclist
    local function my_location_handler(_, result, ctx, config)
        local lsp_util = require("vim.lsp.util")
        local lsp_log = require("vim.lsp.log")
        if result == nil or vim.tbl_isempty(result) then
            local _ = lsp_log.info() and lsp_log.info(ctx.method, "No location found")
            return nil
        end
        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

        if #result == 1 then
            lsp_util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
        else
            config = config or {}
            local title = "LSP locations"
            local items = lsp_util.locations_to_items(result, client.offset_encoding)
            if config.loclist then
                vim.fn.setloclist(0, {}, " ", {
                    title = title,
                    items = items,
                })
                vim.api.nvim_command("botright lopen")
            elseif config.on_list then
                assert(type(config.on_list) == "function", "on_list is not a function")
                config.on_list({ title = title, items = items })
            else
                vim.fn.setqflist({}, " ", {
                    title = title,
                    items = items,
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
end

function M.setup_lsp_keymaps(_, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    -- vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    -- vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
    -- vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", bufopts)
    -- vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_type_definition<CR>", bufopts)

    vim.keymap.set("n", "vgd", ":vsplit | wincmd h | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n", "sgd", ":split | wincmd k | lua vim.lsp.buf.definition()<CR>", bufopts)
    -- vim.keymap.set("n", "vgd", ":vsplit | wincmd h | Lspsaga goto_definition<CR>", bufopts)
    -- vim.keymap.set("n", "sgd", ":split | wincmd k | Lspsaga goto_type_definition<CR>", bufopts)

    vim.keymap.set("n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
    vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.set_loclist()<CR>", bufopts)
    -- vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
    -- vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", bufopts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
    vim.keymap.set({ "n", "v" }, "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>", bufopts)
    vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.codelens.refresh()<CR>", bufopts)
    -- vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set("n", "K", "<cmd>lua require('util.lsp').show_documentation()<CR>", bufopts)
    -- vim.keymap.set("n", "<leader>h", "<cmd>Lspsaga peek_definition<CR>", bufopts)
    -- vim.keymap.set("n", "gs", "<cmd>Lspsaga signature_help<CR>", bufopts)

    vim.keymap.set("n", "gic", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", bufopts)
    vim.keymap.set("n", "goc", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", bufopts)
    -- vim.keymap.set("n", "gic", "<cmd>Lspsaga incoming_calls<CR>", bufopts)
    -- vim.keymap.set("n", "goc", "<cmd>Lspsaga outgoing_calls<CR>", bufopts)

    -- vim.keymap.set("n", "<leader>wf", "<cmd>Lspsaga finder<CR>", bufopts)

    vim.keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true})<CR>", bufopts)

    vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", bufopts)
    vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", bufopts)
    vim.keymap.set("n", "<leader>wl", "<cmd>lua vim.print(vim.lsp.buf.list_workspace_folders())<CR>", bufopts)
end

return M
