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
  Method = utf8(0xf794) .. ' [method]',
  Function = utf8(0xf794) .. ' [function]',
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

local on_attach = function(_, _)
  require'completion'.on_attach({
    chain_complete_list = chain_complete_list,
    customize_lsp_label = customize_lsp_label,
    enable_auto_popup = 1,
    enable_auto_signature = 1,
    auto_change_source = 1,
    enable_auto_hover = 1,
  })
  -- vim.api.nvim_command('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
  if vim.api.nvim_buf_get_option(0, 'filetype') == 'rust' then
    vim.api.nvim_command('autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> lua require"lsp_extensions".inlay_hints{ prefix = " » ", highlight = "NonText" }')
  end
end

require'lspconfig'.diagnosticls.setup{
  cmd = { "diagnostic-languageserver", "--stdio" },
  filetypes = { "sh", "markdown" },
  on_attach = on_attach,
  init_options = {
    filetypes = {
      sh = "shellcheck",
      markdown = "remark",
    },
    linters = {
      remark = {
        sourceName = "remark",
        command = "remark",
        offsetLine = 0,
        offsetColumn = 0,
        formatLines = 1,
        formatPattern = {
          "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
          {
            line = 1,
            column = 2,
            message = 4,
            security = 3
          }
        },
        securities = {
          error = "error",
          warning = "warning",
        }
      },
      shellcheck = {
        sourceName = "shellcheck",
        command = "shellcheck",
        debounce = 100,
        args = { "--format=gcc", "-" },
        offsetLine = 0,
        offsetColumn = 0,
        formatLines = 1,
        formatPattern = {
          "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
          {
            line = 1,
            column = 2,
            message = 4,
            security = 3
          }
        },
        securities = {
          error = "error",
          warning = "warning",
        }
      },
    },
  }
}

local lspconfig = require'lspconfig'
local servers = {
  "tsserver",
  "rust_analyzer",
  "bashls",
  "jsonls",
  "yamlls",
  "html",
  "cmake",
  "dockerls",
  "sqlls",
  "vuels",
  "vimls",
}

for _,name in pairs(servers) do
  lspconfig[name].setup{ on_attach=on_attach }
end

lspconfig.pyls.setup{
  on_attach=on_attach,
  settings = {
    pyls = {
      plugins = {
        pyflakes = {enabled = false},
        pylint = {
          enabled = true,
          executable = "pylint",
        },
        yapf = {
          enabled = true,
        }
      }
    }
  }
}

lspconfig.clangd.setup{
  on_attach=on_attach,
  cmd = {
    "/usr/local/opt/llvm/bin/clangd",
    "--background-index"
  }
}

lspconfig.gopls.setup {
    on_attach=on_attach,
    cmd = {"gopls", "--remote=auto"},
  }

local get_lua_runtime = function()
  local result = {}
  for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. "/lua"
    if vim.fn.isdirectory(lua_path) == 1 then
      result[lua_path] = true
    end
  end

  result[vim.fn.expand("$VIMRUNTIME/lua")] = true

  local user_paths = { "/usr/local/share/lua" }
  for _, path in pairs(user_paths) do
    if vim.fn.isdirectory(path) == 1 then
      result[path] = true
    end
  end
  return result
end

lspconfig.sumneko_lua.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
      -- runtime = { version = "LuaJIT" },
      runtime = { version = "Lua 5.4" },
      diagnostics = {
        enable = true,
        globals = { "vim" },
      },
      workspace = {
        library = get_lua_runtime()
      },
    },
  }
}
