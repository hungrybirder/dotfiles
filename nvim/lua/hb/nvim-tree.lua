require("nvim-tree").setup({
    disable_netrw = false,
    create_in_closed_folder = false,
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    diagnostics = { enable = true },
    update_focused_file = {
        -- enable = false,
        enable = true,
        update_cwd = false,
        ignore_list = {},
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
    renderer = {
        highlight_opened_files = "all",
    },
})

vim.cmd([[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])

vim.keymap.set("n", "<leader><tab>", "<cmd>NvimTreeToggle<CR>")
