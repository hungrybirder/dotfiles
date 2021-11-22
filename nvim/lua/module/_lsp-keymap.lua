local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
end
local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
end

-- local function setup_lsp_handlers()
--     vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
--     vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
--     vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
--     vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
--     vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
--     vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
--     vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
--     vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
-- end

local function setup_lsp_keymaps(client, bufnr)
    -- setup_lsp_handlers()

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gl', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '[d', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('v', '<space>ca', ':lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', '<space>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
    -- buf_set_keymap('v', '<space>ca', ':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)
    buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)

    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- buf_set_keymap('n', 'K', '<Cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
    -- buf_set_keymap('n', '<c-f>', '<Cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    -- buf_set_keymap('n', '<c-b>', '<Cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

    -- peek definition for saving one buffer.
    -- buf_set_keymap('n', '<space>h', '<cmd>lua require("lsp-ext").peek_definition()<CR>', opts)
    buf_set_keymap('n', '<space>h', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)

    -- TODO: learn workspace
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    local function use_ale_fixer(buf_filetype)
        local ale_fixer_filetypes = { "vue", "javascript", "typescript", "python" }
        for _, val in ipairs(ale_fixer_filetypes) do
            if buf_filetype == val then
                return true
            end
        end
        return false
    end

    local buf_ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if use_ale_fixer(buf_ft) then
        print("FileType:", buf_ft, " use ALE Fixer")
    else
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        buf_set_keymap('v', '<space>f', "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
      hi LspReferenceRead ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
      hi LspReferenceWrite ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
      hi LspReferenceText ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
    end
end

return {
    --
    setup_lsp_keymaps = setup_lsp_keymaps
}
