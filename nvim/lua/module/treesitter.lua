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
        ["iC"] = "@class.inner",
        ["aC"] = "@class.outer",
        ["ad"] = "@comment.outer",
        ["ic"] = "@conditional.inner",
        ["ac"] = "@conditional.outer",
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
}

local parsers = require'nvim-treesitter.parsers'
local configs = require'nvim-treesitter.parsers'.get_parser_configs()
local ft_str = table.concat(vim.tbl_map(function(ft) return configs[ft].filetype or ft end, parsers.available_parsers()), ',')
-- TODO: learn vim folder
-- vim.cmd('autocmd Filetype ' .. ft_str .. ' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')
vim.cmd('autocmd VimEnter * TSContextDisable')
