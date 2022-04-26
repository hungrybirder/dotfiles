local M = {}

M.setup_lsp_keymaps = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)

    buf_set_keymap("n", "vgd", ":vsplit | wincmd h | lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "sgd", ":split | wincmd k | lua vim.lsp.buf.definition()<CR>", opts)

    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "gl", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<space>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("v", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)

    buf_set_keymap("n", "gic", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
    buf_set_keymap("n", "goc", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)

    buf_set_keymap("n", "gs", "<cmd>Lspsaga signature_help<CR>", opts)
    -- buf_set_keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    -- buf_set_keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

    buf_set_keymap("n", "<space>h", '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)

    -- TODO: learn workspace
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
      hi LspReferenceRead ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
      hi LspReferenceWrite ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
      hi LspReferenceText ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
            ]],
            false
        )
    end
end

return M
