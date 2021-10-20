vim.o.termguicolors = true
vim.api.nvim_exec([[
  highlight NvimTreeFolderIcon guibg=blue
]], false)

vim.g.nvim_tree_ignore = {'.git', 'node_modules', '.cache'}
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 0
vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_icon_padding = ' '
vim.g.nvim_tree_symlink_arrow = ' >> '
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_create_in_closed_folder = 0
vim.g.nvim_tree_refresh_wait = 500

-- vim.g.nvim_tree_auto_close = 1
-- vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
-- vim.g.nvim_tree_follow = 1
-- vim.g.nvim_tree_tab_open = 0
-- vim.g.nvim_tree_width_allow_resize  = 1
-- vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_window_picker_exclude = {filetype = {'packer', 'qf'}, buftype = {'terminal'}}

vim.g.nvim_tree_special_files = {['README.md'] = true, Makefile = true, MAKEFILE = true}

vim.g.nvim_tree_show_icons = {git = 1, folders = 1, files = 1}

require'nvim-tree'.setup {
    disable_netrw = false,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    auto_close = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    diagnostics = {enable = true},
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
        -- enables the feature
        enable = false,
        -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
        -- only relevant when `update_focused_file.enable` is true
        update_cwd = false,
        -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
        -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
        ignore_list = {}
    },
    -- configuration options for the system open command (`s` in the tree by default)
    system_open = {
        -- the command to run this, leaving nil should work in most cases
        cmd = nil,
        -- the command arguments as a list
        args = {}
    },

    view = {
        -- width of the window, can be either a number (columns) or a string in `%`
        width = 30,
        -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
        side = 'left',
        -- if true the tree will resize itself after opening a file
        auto_resize = false,
        mappings = {
            -- custom only false will merge the list with the default mappings
            -- if true, it will only use your list to set the mappings
            custom_only = false,
            -- list of mappings to set on the tree manually
            list = {}
        }
    }
}

-- mapping
vim.api.nvim_set_keymap('n', '<leader><tab>', '<cmd>NvimTreeToggle<CR>', {noremap = true, silent = true})

local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_bindings = {
    {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
    {key = {"<2-RightMouse>", "<C-}>"}, cb = tree_cb("cd")}, {key = "<C-v>", cb = tree_cb("vsplit")},
    {key = "<C-x>", cb = tree_cb("split")}, {key = "<C-t>", cb = tree_cb("tabnew")},
    {key = "<", cb = tree_cb("prev_sibling")}, {key = ">", cb = tree_cb("next_sibling")},
    {key = "P", cb = tree_cb("parent_node")}, {key = "<BS>", cb = tree_cb("close_node")},
    {key = "<S-CR>", cb = tree_cb("close_node")}, {key = "<Tab>", cb = tree_cb("preview")},
    {key = "K", cb = tree_cb("first_sibling")}, {key = "J", cb = tree_cb("last_sibling")},
    {key = "I", cb = tree_cb("toggle_ignored")}, {key = "H", cb = tree_cb("toggle_dotfiles")},
    {key = "R", cb = tree_cb("refresh")}, {key = "a", cb = tree_cb("create")}, {key = "d", cb = tree_cb("remove")},
    {key = "r", cb = tree_cb("rename")}, {key = "<C->", cb = tree_cb("full_rename")}, {key = "x", cb = tree_cb("cut")},
    {key = "c", cb = tree_cb("copy")}, {key = "p", cb = tree_cb("paste")}, {key = "y", cb = tree_cb("copy_name")},
    {key = "Y", cb = tree_cb("copy_path")}, {key = "gy", cb = tree_cb("copy_absolute_path")},
    {key = "[c", cb = tree_cb("prev_git_item")}, {key = "}c", cb = tree_cb("next_git_item")},
    {key = "-", cb = tree_cb("dir_up")}, {key = "q", cb = tree_cb("close")}, {key = "g?", cb = tree_cb("toggle_help")}
}
