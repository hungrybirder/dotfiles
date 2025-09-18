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

function M.setup_lsp_keymaps(_, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Open Diagnostic Float Window",
    })

    vim.keymap.set("n", "gl", vim.diagnostic.setloclist, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Set Diagnostic Loclist",
    })
    --
    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition({
            loclist = true,
        })
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Goto Definition",
    })

    vim.keymap.set("n", "gD", function()
        vim.lsp.buf.declaration({ loclist = true })
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Goto Declaration",
    })

    vim.keymap.set("n", "<leader>i", function()
        vim.lsp.buf.implementation({ loclist = true })
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Goto Implementation",
    })

    vim.keymap.set("n", "gr", function()
        vim.lsp.buf.references(nil, { loclist = true })
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Goto References",
    })

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Rename",
    })

    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Code Action",
    })

    vim.keymap.set({ "n", "v" }, "<leader>cl", vim.lsp.codelens.run, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "CodeLens Run",
    })

    vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.refresh, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "CodeLens Refresh",
    })

    vim.keymap.set("n", "K", "<cmd>lua require('util.lsp').show_documentation()<CR>", {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Show Documentation",
    })

    vim.keymap.set("n", "gic", vim.lsp.buf.incoming_calls, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Incoming Calls",
    })

    vim.keymap.set("n", "goc", vim.lsp.buf.outgoing_calls, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Outgoing Calls",
    })

    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Format",
    })

    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Add Workspace Folder",
    })

    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Remove Workspace Folder",
    })

    vim.keymap.set("n", "<leader>wl", function()
        vim.print(vim.lsp.buf.list_workspace_folders())
    end, {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "List Workspace Folders",
    })

    vim.keymap.set("n", "vgd", ":vsplit | wincmd h | lua vim.lsp.buf.definition()<CR>", {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Vertical Split Goto Definition",
    })

    vim.keymap.set("n", "sgd", ":split | wincmd k | lua vim.lsp.buf.definition()<CR>", {
        noremap = true,
        silent = true,
        buffer = bufnr,
        desc = "Split Goto Definition",
    })
end

function M.lsp_on_attach_post(client, bufnr)
    M.setup_lsp_keymaps(client, bufnr)

    require("lspkind").init({
        symbol_map = {
            Supermaven = "",
        },
    })

    -- config providers
    if client.server_capabilities.documentHighlightProvider then
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

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, {
            bufnr = bufnr,
        })
    end

    if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh()
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        local buf_cl_group = "codelens" .. buf_ft
        vim.api.nvim_create_augroup(buf_cl_group, { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = buf_cl_group,
            pattern = { "*." .. buf_ft },
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })
    end
end

return M
