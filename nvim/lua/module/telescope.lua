local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local telescope = require('telescope')

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
                ["<c-w>"] = actions.send_selected_to_qflist,
                ["<c-q>"] = actions.send_to_qflist
            },
            n = {
                -- send selected to quickfix
                ["<c-w>"] = actions.send_selected_to_qflist,
                -- send all to quickfix
                ["<c-q>"] = actions.send_to_qflist
            }
        },
        vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "flex",
        scroll_strategy = 'cycle',
        layout_config = { horizontal = { mirror = false }, vertical = { mirror = false } },
        file_sorter = require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
        path_display = { "absolute" },
        winblend = 5,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = previewers.buffer_previewer_maker
    },
    extensions = { fzy_native = { override_generic_sorter = false, override_file_sorter = true } }
}

telescope.load_extension('fzy_native')

vim.notify = require("notify")
vim.notify.setup({ render = "fade" })

-- require'telescope.builtin'.symbol{ sources = {'emoji'} }
