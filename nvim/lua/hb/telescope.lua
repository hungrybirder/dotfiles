local actions = require('telescope.actions')
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
        layout_strategy = "flex",
        file_ignore_patterns = { ".clang", ".trash" },
        path_display = { "truncate" },
        winblend = 5
        -- set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        -- file_previewer = previewers.vim_buffer_cat.new,
        -- grep_previewer = previewers.vim_buffer_vimgrep.new,
        -- qflist_previewer = previewers.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        -- buffer_previewer_maker = previewers.buffer_previewer_maker
    },
    pickers = { --
        lsp_range_code_actions = { theme = "cursor" },
        lsp_code_actions = { theme = "cursor" },
        commands = { theme = "dropdown" },
        current_buffer_fuzzy_find = { theme = "dropdown" },
        grep_string = { theme = "dropdown" },
        jumplist = { theme = "dropdown" },
        live_grep = { theme = "dropdown" },
        man_pages = { sections = { "2", "3" } },
        lsp_references = { path_display = { "shorten" } },
        lsp_document_symbols = { path_display = { "hidden" }, theme = "ivy" },
        lsp_workspace_symbols = { path_display = { "shorten" }, theme = "ivy" },
        oldfiles = { theme = "dropdown" },
        tagstack = { theme = "dropdown" },
        treesitter = { theme = "dropdown" },
        git_branches = { theme = "dropdown" },

        git_files = { theme = "dropdown", previewer = false },
        find_files = { theme = "dropdown", previewer = false },
        file_browser = { theme = "dropdown", previewer = false },
        buffers = {
            sort_mru = true,
            theme = "dropdown",
            selection_strategy = "closest",
            previewer = false,
            mappings = { i = { ["<c-d>"] = actions.delete_buffer } }
        },
        current_buffer_fuzzy_find = { theme = "dropdown" }
    },
    extensions = {
        -- fzy_native = { override_generic_sorter = false, override_file_sorter = true }
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
        -- ["ui-select"] = {
        --     require("telescope.themes").get_dropdown {
        --     }
        -- }
    }
}

telescope.load_extension('fzf')
-- telescope.load_extension('fzy_native')
-- telescope.load_extension('ui-select')
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
set_keymap('n', '<leader>gc',  '<cmd>Telescope git_branches<CR>', opts)
-- LuaFormatter on