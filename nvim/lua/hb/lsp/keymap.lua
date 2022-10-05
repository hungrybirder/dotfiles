---@diagnostic disable: missing-parameter, unused-local
local M = {}

function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end

vim.keymap.set("n", "K", "<cmd>lua show_documentation()<CR>")

M.setup_lsp_keymaps = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)

    vim.keymap.set("n", "vgd", ":vsplit | wincmd h | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n", "sgd", ":split | wincmd k | lua vim.lsp.buf.definition()<CR>", bufopts)

    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
    vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.set_loclist()<CR>", bufopts)
    vim.keymap.set("n", "<space>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
    vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
    vim.keymap.set("n", "<space>ca", "<cmd>Lspsaga code_action<CR>", bufopts)
    vim.keymap.set("v", "<space>ca", ":Lspsaga range_code_action<CR>", bufopts)
    vim.keymap.set("n", "<space>cl", "<cmd>lua vim.lsp.codelens.run()<CR>", bufopts)
    vim.keymap.set("n", "<space>cr", "<cmd>lua vim.lsp.codelens.refresh()<CR>", bufopts)
    -- vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set("n", "gic", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", bufopts)
    vim.keymap.set("n", "goc", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", bufopts)
    vim.keymap.set("n", "gs", "<cmd>Lspsaga signature_help<CR>", bufopts)
    vim.keymap.set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", bufopts)
    vim.keymap.set("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", bufopts)
    vim.keymap.set("n", "<space>h", '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', bufopts)
    vim.keymap.set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", bufopts)
    vim.keymap.set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", bufopts)
    vim.keymap.set("n", "<space>wl", "<cmd>lua vim.pretty_print(vim.lsp.buf.list_workspace_folders())<CR>", bufopts)

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
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
