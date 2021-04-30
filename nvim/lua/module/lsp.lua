-- [[
-- FROM https://github.com/neovim/neovim/wiki/Following-HEAD
-- LspInstall LspInstallInfo is deprecated.
-- FROM https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
-- Install language server by myself.
-- ]]

local SEP = "/"
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

local lsp_install_path = vim.fn.stdpath('cache')..SEP..'lspconfig'

local lspconfig = require'lspconfig'
local util      = require'lspconfig/util'
local lsp_status = require('lsp-status')
local lspsaga = require 'lspsaga'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- lsp handlers are powered by nvim-lsputils
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

local chain_complete_list = {
  default = {
    {complete_items = {'lsp'}},
    {complete_items = {'buffers'}},
    {complete_items = {'snippet'}},
    {complete_items = {'path'}, triggered_only = {'./', '/'}},
  },
  string = {
    {complete_items = {'path'}, triggered_only = {'./', '/'}},
    {complete_items = {'buffers'}},
  },
  comment = {},
  lua = {
    {complete_items = {'lsp'}},
    {complete_items = {'buffers'}},
    {complete_items = {'path'}, triggered_only = {'./', '/'}},
  },
}
local utf8 = function(cp)
  if cp < 128 then
    return string.char(cp)
  end
  local s = ""
  local prefix_max = 32
  while true do
    local suffix = cp % 64
    s = string.char(128 + suffix)..s
    cp = (cp - suffix) / 64
    if cp < prefix_max then
      return string.char((256 - (2 * prefix_max)) + cp)..s
    end
    prefix_max = prefix_max / 2
  end
end
local customize_lsp_label = {
  Method = utf8(0xf794) .. ' [Method]',
  Function = utf8(0xf794) .. ' [Function]',
  Variable = utf8(0xf6a6) .. ' [variable]',
  Field = utf8(0xf6a6) .. ' [field]',
  Class = utf8(0xfb44) .. ' [class]',
  Struct = utf8(0xfb44) .. ' [struct]',
  Interface = utf8(0xf836) .. ' [interface]',
  Module = utf8(0xf668) .. ' [module]',
  Property = utf8(0xf0ad) .. ' [property]',
  Value = utf8(0xf77a) .. ' [value]',
  Enum = utf8(0xf77a) .. ' [enum]',
  Operator = utf8(0xf055) .. ' [operator]',
  Reference = utf8(0xf838) .. ' [reference]',
  Keyword = utf8(0xf80a) .. ' [keyword]',
  Color = utf8(0xe22b) .. ' [color]',
  Unit = utf8(0xe3ce) .. ' [unit]',
  ["snippets.nvim"] = utf8(0xf68e) .. ' [nsnip]',
  Snippet = utf8(0xf68e) .. ' [snippet]',
  Text = utf8(0xf52b) .. ' [text]',
  Buffers = utf8(0xf64d) .. ' [buffers]',
  TypeParameter = utf8(0xf635) .. ' [type]',
}

local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gl', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('v', '<space>ca', ':lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
  buf_set_keymap('v', '<space>ca', ':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)


  -- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
  buf_set_keymap('n', '<c-f>', '<Cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
  buf_set_keymap('n', '<c-b>', '<Cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

  -- peek definition for saving one buffer.
  -- buf_set_keymap('n', '<space>h', '<cmd>lua require("lsp-ext").peek_definition()<CR>', opts)
  buf_set_keymap('n', '<space>h', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', opts)

  -- TODO: learn workspace
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
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

  require'completion'.on_attach({
    chain_complete_list = chain_complete_list,
    customize_lsp_label = customize_lsp_label,
  })

  lsp_status.on_attach(client)
  require "lsp_signature".on_attach({
      bind = true,
      handler_opts = {
        border = "single"
      }
  })
  -- vim.api.nvim_command('autocmd CursorHold <buffer> lua require"lspsaga.diagnostic".show_line_diagnostics()')
  -- vim.api.nvim_command('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
  -- if vim.api.nvim_buf_get_option(0, 'filetype') == 'rust' then
  --   vim.api.nvim_command('autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs lua require"lsp_extensions".inlay_hints {prefix=" » ", highlight = "Comment", enabled = {"TypeHint","ChainingHint", "ParameterHint"}}')
  -- end
end

lsp_status.register_progress()
lsp_status.config({
  status_symbol = '',
  indicator_errors = 'e',
  indicator_warnings = 'w',
  indicator_info = 'i',
  indicator_hint = 'h',
  indicator_ok = 'ok',
})

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
local servers = {
  "jsonls",
  "yamlls",
  "html",
  "cmake",
  "dockerls",
  "vuels",
  "tsserver",
  "vimls",
  "bashls",
}

for _,name in pairs(servers) do
  lspconfig[name].setup{
    on_attach=on_attach,
    -- capabilities = capabilities,
    capabilities = lsp_status.capabilities,
  }
end

lspconfig.sqlls.setup{
  cmd = {"sql-language-server", "up", "--method", "stdio"};
}

lspconfig.pyright.setup{
  on_attach=on_attach,
  capabilities = lsp_status.capabilities,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      },
      linting = {
        enable = true,
        pylintEnabled = true,
      },
      formatting = {
        provider = "yapf",
      },
    }
  }
}

lspconfig.clangd.setup{
  on_attach=on_attach,
  capabilities = lsp_status.capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "-j=8",
  }
}

lspconfig.gopls.setup {
  on_attach=on_attach,
  capabilities = lsp_status.capabilities,
  cmd = {"gopls", "--remote=auto"},
}

local get_lua_runtime = function()
  local result = {}
  local rtps = vim.api.nvim_list_runtime_paths()
  local extra_paths = {
    vim.fn.expand("$VIMRUNTIME"),
    -- "/usr/local/share",
    -- "/opt/homebrew/share",
  }
  for _, path in pairs(extra_paths) do
      rtps[#rtps+1] = path
  end
  -- for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
  for _, path in pairs(rtps) do
    local lua_path = path .. "/lua"
    if vim.fn.isdirectory(lua_path) == 1 then
      result[lua_path] = true
    end
  end
  local local_luarocks = require("os").getenv("HOME") .. "/" .. ".luarocks/share/lua/5.1"
  if vim.fn.isdirectory(local_luarocks) == 1 then
    result[local_luarocks] = true
  end
  return result
end

local sumneko_root_path = lsp_install_path..'/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
lspconfig.sumneko_lua.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        -- path = vim.split(package.path, ";")
      },
      -- runtime = { version = "Lua 5.4" },
      diagnostics = {
        enable = true,
        globals = { "vim" },
      },
      workspace = {
        library = get_lua_runtime(),
        preloadFileSize = 1024, -- KB
      },
    },
  }
}

-- on MacOS
-- brew tap hungrybirder/homebrew-repo
-- brew install jdt-language-server
lspconfig.jdtls.setup{
  on_attach=on_attach,
  cmd = {"jdt-language-server"},
  root_dir = util.root_pattern(".git", "pom.xml"),
}

lspconfig.solargraph.setup{
  on_attach=on_attach,
  cmd = {
    "/usr/local/lib/ruby/gems/3.0.0/bin/solargraph",
    "stdio"
  }
}

-- setup rust-tools
capabilities.experimental = {}
capabilities.experimental.hoverActions = true

capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
}
local opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        runnables = {
            use_telescope = true
        },
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "<-",
            other_hints_prefix  = "=>",
        },
    },
    server = { -- setup rust_analyzer
      on_attach = on_attach,
      capabilities = capabilities,
    }
}

require('rust-tools').setup(opts)
require('rust-tools-debug').setup()
-- setup rust-tools end

-- setup outline
require('symbols-outline').setup()
-- setup outline end

-- lspsaga
lspsaga.init_lsp_saga{
  code_action_keys = {
    quit = '<esc>',
    exec = '<CR>',
  },
}
-- lspsaga end
