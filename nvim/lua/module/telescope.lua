local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local telescope = require('telescope')
local action_layout = require('telescope.actions.layout')

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
                ["<c-w>"] = actions.send_selected_to_qflist,
                ["<c-q>"] = actions.send_to_qflist,
                ['<M-p>'] = action_layout.toggle_preview
            },
            n = {
                -- send selected to quickfix
                ["<c-w>"] = actions.send_selected_to_qflist,
                -- send all to quickfix
                ["<c-q>"] = actions.send_to_qflist,
                ['<M-p>'] = action_layout.toggle_preview
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
    extensions = { fzy_native = { override_generic_sorter = false, override_file_sorter = true } },
    pickers = { --
        lsp_range_code_actions = { theme = "cursor" },
        lsp_code_actions = { theme = "cursor" },
        buffers = { theme = "ivy" },
        commands = { theme = "ivy" },
        current_buffer_fuzzy_find = { theme = "ivy" },
        find_files = { theme = "ivy" },
        git_files = { theme = "ivy" },
        grep_string = { theme = "ivy" },
        jumplist = { theme = "ivy" },
        live_grep = { theme = "ivy" },
        lsp_document_symbols = { theme = "ivy" },
        lsp_references = { theme = "ivy" },
        lsp_workspace_symbols = { theme = "ivy" },
        oldfiles = { theme = "ivy" },
        tagstack = { theme = "ivy" },
        treesitter = { theme = "ivy" },
    }
}

telescope.load_extension('fzy_native')
-- require'telescope.builtin'.symbol{ sources = {'emoji'} }

-- LuaFormatter off
-- telescope mappings
local opts = { noremap = true, silent = true }
local set_keymap = vim.api.nvim_set_keymap
set_keymap('n', '<c-p>', '<cmd>Telescope git_files<CR>', opts)
set_keymap('n', '<leader>m',  '<cmd>Telescope oldfiles<CR>', opts)
set_keymap('n', '<leader>b',  '<cmd>Telescope buffers<CR>', opts)
set_keymap('n', '<leader>a',  '<cmd>Telescope live_grep<CR>', opts)
set_keymap('n', '<leader>r',  '<cmd>Telescope lsp_references<CR>', opts)
set_keymap('n', '<leader>ts', '<cmd>Telescope tagstack<CR>', opts)
set_keymap('n', '<leader>tc', '<cmd>Telescope commands<CR>', opts)
set_keymap('n', '<leader>jl', '<cmd>Telescope jumplist<CR>', opts)
set_keymap('n', '<Leader>pf', '<cmd>Telescope find_files<CR>', opts)
set_keymap('n', '<leader>pb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
set_keymap('n', '<leader>cs', '<cmd>Telescope lsp_document_symbols<CR>', opts)
set_keymap('n', '<leader>ws', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols{query="*"}<CR>', opts)
set_keymap('n', '<leader>ps', '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ")})<CR>', opts)
set_keymap('n', '<leader>pw', '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>', opts)
set_keymap('n', '<leader>o',  '<cmd>Telescope lsp_document_symbols symbols=["method","function","module","interface"]<CR>', opts)
-- LuaFormatter on
