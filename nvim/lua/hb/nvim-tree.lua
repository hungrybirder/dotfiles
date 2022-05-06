vim.o.termguicolors = true
-- vim.api.nvim_exec([[highlight NvimTreeFolderIcon guibg=blue]], false)

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ":~"
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_icon_padding = " "
vim.g.nvim_tree_symlink_arrow = " >> "
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_create_in_closed_folder = 0
vim.g.nvim_tree_refresh_wait = 500

vim.g.nvim_tree_special_files = { ["README.md"] = true, Makefile = true, MAKEFILE = true }

vim.g.nvim_tree_show_icons = { git = 1, folders = 1, files = 1 }

require("nvim-tree").setup({
    disable_netrw = false,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    diagnostics = { enable = true },
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
        -- enables the feature
        enable = false,
        -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
        -- only relevant when `update_focused_file.enable` is true
        update_cwd = false,
        -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
        -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
        ignore_list = {},
    },
    -- configuration options for the system open command (`s` in the tree by default)
    system_open = {
        -- the command to run this, leaving nil should work in most cases
        cmd = nil,
        -- the command arguments as a list
        args = {},
    },

    view = {
        width = 30,
        side = "left",
        mappings = {
            custom_only = false,
            list = {
                { key = "<C-e>", action = "" }, -- disable edit_in_place
            },
        },
    },
    filters = {
        dotfiles = false,
        -- ignore some dirs
        custom = { ".git", "node_modules", ".cache" },
    },
})

vim.keymap.set("n", "<leader><tab>", "<cmd>NvimTreeToggle<CR>")

vim.cmd([[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
