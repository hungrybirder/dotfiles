require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    }
  },
  refactor = {
    highlight_definitions = { enable = false },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      }
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      }
    }
  },
  -- nvim-treesitter/nvim-treesitter-textobjects
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["ie"] = "@block.inner",
        ["ae"] = "@block.outer",
        ["im"] = "@call.inner",
        ["am"] = "@call.outer",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
        ["ad"] = "@comment.outer",
        ["iC"] = "@conditional.inner",
        ["aC"] = "@conditional.outer",
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["is"] = "@parameter.inner",
        ["as"] = "@statement.outer",
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
  playground = {
    enable = true,
    -- disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false -- Whether the query persists across vim sessions
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
}

-- local parsers = require'nvim-treesitter.parsers'
-- local configs = require'nvim-treesitter.parsers'.get_parser_configs()
-- local ft_str = table.concat(vim.tbl_map(function(ft) return configs[ft].filetype or ft end, parsers.available_parsers()), ',')
-- TODO: learn vim folder
-- vim.cmd('autocmd Filetype ' .. ft_str .. ' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')

-- tmp diable context
vim.cmd('autocmd VimEnter * TSContextDisable')
