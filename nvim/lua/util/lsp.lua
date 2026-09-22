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
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end

    map("n", "<leader>e", vim.diagnostic.open_float, "Open Diagnostic Float Window")
    map("n", "gl", vim.diagnostic.setloclist, "Set Diagnostic Loclist")
    map("n", "gd", function()
        vim.lsp.buf.definition({ loclist = true })
    end, "Goto Definition")
    map("n", "gD", function()
        vim.lsp.buf.declaration({ loclist = true })
    end, "Goto Declaration")
    map("n", "<leader>i", function()
        vim.lsp.buf.implementation({ loclist = true })
    end, "Goto Implementation")
    map("n", "gr", function()
        vim.lsp.buf.references(nil, { loclist = true })
    end, "Goto References")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map({ "n", "v" }, "<leader>cl", vim.lsp.codelens.run, "CodeLens Run")
    map("n", "K", M.show_documentation, "Show Documentation")
    map("n", "gic", vim.lsp.buf.incoming_calls, "Incoming Calls")
    map("n", "goc", vim.lsp.buf.outgoing_calls, "Outgoing Calls")
    map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, "Format")
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
    map("n", "<leader>wl", function()
        vim.print(vim.lsp.buf.list_workspace_folders())
    end, "List Workspace Folders")
    map("n", "vgd", ":vsplit | wincmd h | lua vim.lsp.buf.definition()<CR>", "Vertical Split Goto Definition")
    map("n", "sgd", ":split | wincmd k | lua vim.lsp.buf.definition()<CR>", "Split Goto Definition")
end

function M.lsp_on_attach_post(client, bufnr)
    M.setup_lsp_keymaps(client, bufnr)

    if client:supports_method("textDocument/inlayHint", bufnr) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Neovim 0.12 重写了 codelens：enable 后会自动刷新，不再需要 BufWritePost autocmd
    if client:supports_method("textDocument/codeLens", bufnr) then
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end
end

return M
