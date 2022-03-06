RELOAD = require("plenary.reload").reload_module
RTELE = function()
    RELOAD("hb.telescope")
    RELOAD("telescope")
end

local actions = require("telescope.actions")
local telescope = require("telescope")
local action_layout = require("telescope.actions.layout")
local trouble = require("trouble.providers.telescope")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
                ["<c-w>"] = actions.send_selected_to_qflist,
                ["<c-q>"] = actions.send_to_qflist,
                ["<c-l>"] = actions.add_selected_to_loclist,
                ["<c-h>"] = actions.send_to_loclist,
                ["<M-p>"] = action_layout.toggle_preview,
                ["<c-t>"] = trouble.open_with_trouble,
            },
            n = {
                ["<c-w>"] = actions.send_selected_to_qflist,
                ["<c-q>"] = actions.send_to_qflist,
                ["<c-l>"] = actions.add_selected_to_loclist,
                ["<c-h>"] = actions.send_to_loclist,
                ["<M-p>"] = action_layout.toggle_preview,
                ["<c-t>"] = trouble.open_with_trouble,
            },
        },
        layout_strategy = "flex",
        file_ignore_patterns = { ".clang", ".trash" },
        path_display = { "truncate" },
        winblend = 5,
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
        jumplist = { theme = "ivy", previewer = false },
        loclist = { theme = "ivy", previewer = false },
        live_grep = { theme = "dropdown" },
        man_pages = { sections = { "2", "3" } },
        lsp_references = { path_display = { "shorten" } },
        lsp_document_symbols = { path_display = { "hidden" }, theme = "ivy" },
        lsp_workspace_symbols = { path_display = { "shorten" }, theme = "ivy" },
        oldfiles = { theme = "dropdown" },
        tagstack = { theme = "dropdown" },
        treesitter = { theme = "dropdown" },
        git_branches = { theme = "dropdown" },
        marks = { theme = "ivy", previewer = false },

        git_files = { theme = "dropdown", previewer = false },
        find_files = { theme = "dropdown", previewer = false },
        file_browser = { theme = "dropdown", previewer = false },
        buffers = {
            sort_mru = true,
            theme = "dropdown",
            selection_strategy = "closest",
            previewer = false,
            mappings = { i = { ["<c-d>"] = actions.delete_buffer } },
        },
    },
    extensions = {
        -- fzy_native = { override_generic_sorter = false, override_file_sorter = true }
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        -- ["ui-select"] = {
        --     require("telescope.themes").get_dropdown {
        --     }
        -- }
    },
})

telescope.load_extension("fzf")
telescope.load_extension("notify")
-- telescope.load_extension('fzy_native')
-- telescope.load_extension('ui-select')
-- require'telescope.builtin'.symbol{ sources = {'emoji'} }

-- telescope mappings
local hb_utils = require("hb/utils")
local remap = hb_utils.remap
local opts = hb_utils.opt_noremap_silent

remap("n", "<c-p>", "<cmd>lua RTELE(); require'telescope.builtin'.git_files{}<CR>", opts)
remap("n", "<leader>m", "<cmd>lua RTELE(); require'telescope.builtin'.oldfiles{}<CR>", opts)
remap("n", "<leader>n", "<cmd>lua RTELE(); require'telescope.builtin'.marks{}<CR>", opts)
remap("n", "<leader>b", "<cmd>lua RTELE(); require'telescope.builtin'.buffers{}<CR>", opts)
remap("n", "<leader>a", "<cmd>lua RTELE(); require'telescope.builtin'.live_grep{}<CR>", opts)
remap("n", "<leader>F", "<cmd>lua RTELE(); require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>", opts)
remap("n", "<leader>ts", "<cmd>lua RTELE(); require'telescope.builtin'.tagstack{}<CR>", opts)
remap("n", "<leader>cc", "<cmd>lua RTELE(); require'telescope.builtin'.commands{}<CR>", opts)
remap("n", "<leader>jl", "<cmd>lua RTELE(); require'telescope.builtin'.jumplist{}<CR>", opts)
remap("n", "<F2>", "<cmd>Telescope resume<CR>", opts)
remap("n", "<leader>pf", "<cmd>lua RTELE(); require'telescope.builtin'.find_files{}<CR>", opts)
remap(
    "n",
    "<leader>ps",
    "<cmd>lua RTELE(); require'telescope.builtin'.grep_string({ search = vim.fn.input('Grep For > ')})<CR>",
    opts
)
remap(
    "n",
    "<leader>pw",
    "<cmd>lua RTELE(); require'telescope.builtin'.grep_string({ search = vim.fn.expand('<cword>') })<CR>",
    opts
)
remap("n", "<leader>r", "<cmd>lua RTELE(); require'telescope.builtin'.lsp_references{}<CR>", opts)
remap("n", "<leader>ws", "<cmd>lua RTELE(); require'telescope.builtin'.lsp_workspace_symbols{ query = '*' }<CR>", opts)
remap("n", "<leader>cs", "<cmd>lua RTELE(); require'telescope.builtin'.lsp_document_symbols{}<CR>", opts)
remap(
    "n",
    "<leader>o",
    "<cmd>lua RTELE(); require'telescope.builtin'.lsp_document_symbols{ symbols = {'method', 'function', 'module', 'interface' } }<CR>",
    opts
)
remap("n", "<leader>gc", "<cmd>lua RTELE(); require'telescope.builtin'.git_branches{}<CR>", opts)
