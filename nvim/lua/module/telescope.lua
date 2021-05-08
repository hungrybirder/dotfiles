local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
require('telescope').setup{
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    mappings = {
      i = {
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
        ["<c-w>"] = actions.send_selected_to_qflist,
        ["<c-q>"] = actions.send_to_qflist,
      },
      n = {
        ["<c-w>"] = actions.send_selected_to_qflist,
        ["<c-q>"] = actions.send_to_qflist,
      },
    },
    layout_strategy = "flex",
    scroll_strategy = 'cycle',
    winblend = 5,
    layout_defaults = {
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = 0.55,
      },
    },
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
  },
  extensions = {
    fzf = {
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
    -- fzf_writer = {
    --     use_highlighter = true,
    -- },
  }
}
-- require('telescope').load_extension('fzy_native')
require('telescope').load_extension('fzf')

-- require'telescope.builtin'.symbol{ sources = {'emoji'} }
