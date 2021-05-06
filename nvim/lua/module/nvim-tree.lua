vim.g.nvim_tree_side = 'left'
vim.g.nvim_tree_width = 30
vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 0
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_tab_open = 0
vim.g.nvim_tree_width_allow_resize  = 1
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_special_files = { 'README.md', 'Makefile', 'MAKEFILE' }
vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
}

-- mapping
vim.api.nvim_set_keymap('n', '<leader><tab>', '<cmd>NvimTreeToggle<CR>', {noremap = true, silent = true,})

local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_bindings = {
  -- default mappings
  ["<CR>"]           = tree_cb("edit"),
  ["o"]              = tree_cb("edit"),
  ["<2-LeftMouse>"]  = tree_cb("edit"),
  ["<2-RightMouse>"] = tree_cb("cd"),
  ["<C-]>"]          = tree_cb("cd"),
  ["<C-v>"]          = tree_cb("vsplit"),
  ["<C-s>"]          = tree_cb("split"),
  ["<C-t>"]          = tree_cb("tabnew"),
  ["<"]              = tree_cb("prev_sibling"),
  [">"]              = tree_cb("next_sibling"),
  ["<BS>"]           = tree_cb("close_node"),
  ["<S-CR>"]         = tree_cb("close_node"),
  ["<Tab>"]          = tree_cb("preview"),
  ["I"]              = tree_cb("toggle_ignored"),
  ["H"]              = tree_cb("toggle_dotfiles"),
  ["R"]              = tree_cb("refresh"),
  ["a"]              = tree_cb("create"),
  ["d"]              = tree_cb("remove"),
  ["r"]              = tree_cb("rename"),
  ["<C-r>"]          = tree_cb("full_rename"),
  ["x"]              = tree_cb("cut"),
  ["c"]              = tree_cb("copy"),
  ["p"]              = tree_cb("paste"),
  ["[c"]             = tree_cb("prev_git_item"),
  ["]c"]             = tree_cb("next_git_item"),
  ["-"]              = tree_cb("dir_up"),
  ["q"]              = tree_cb("close"),
}
