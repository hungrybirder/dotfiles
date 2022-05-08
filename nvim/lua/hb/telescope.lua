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
    },
    pickers = { --
        commands = { theme = "ivy", previewer = false },
        current_buffer_fuzzy_find = { theme = "ivy" },
        grep_string = { theme = "ivy" },
        jumplist = { theme = "ivy", previewer = false },
        loclist = { theme = "ivy", previewer = false },
        live_grep = { theme = "ivy" },
        man_pages = { sections = { "2", "3" } },
        lsp_references = { path_display = { "shorten" } },
        lsp_document_symbols = { path_display = { "hidden" }, theme = "ivy" },
        lsp_workspace_symbols = { path_display = { "shorten" }, theme = "ivy" },
        oldfiles = { theme = "ivy", previewer = false },
        tagstack = { theme = "ivy" },
        treesitter = { theme = "ivy" },
        git_branches = { theme = "ivy" },
        marks = { theme = "ivy", previewer = false },
        git_files = { theme = "ivy" },
        find_files = { theme = "ivy" },
        file_browser = { theme = "ivy" },
        buffers = {
            sort_mru = true,
            theme = "ivy",
            selection_strategy = "closest",
            previewer = false,
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("notify")
-- telescope.load_extension('fzy_native')
-- telescope.load_extension('ui-select')
-- require'telescope.builtin'.symbol{ sources = {'emoji'} }

-- telescope mappings
vim.keymap.set("n", "<c-p>", "<cmd>lua RTELE(); require'telescope.builtin'.git_files{}<CR>")
vim.keymap.set("n", "<leader>m", "<cmd>lua RTELE(); require'telescope.builtin'.oldfiles{}<CR>")
vim.keymap.set("n", "<leader>n", "<cmd>lua RTELE(); require'telescope.builtin'.marks{}<CR>")
vim.keymap.set("n", "<leader>b", "<cmd>lua RTELE(); require'telescope.builtin'.buffers{}<CR>")
-- remap("n", "<leader>a", "<cmd>lua RTELE(); require'telescope.builtin'.live_grep{}<CR>", opts)
vim.keymap.set("n", "<leader>F", "<cmd>lua RTELE(); require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>")
vim.keymap.set("n", "<leader>ts", "<cmd>lua RTELE(); require'telescope.builtin'.tagstack{}<CR>")
vim.keymap.set("n", "<leader>cc", "<cmd>lua RTELE(); require'telescope.builtin'.commands{}<CR>")
vim.keymap.set("n", "<leader>jl", "<cmd>lua RTELE(); require'telescope.builtin'.jumplist{}<CR>")
vim.keymap.set("n", "<F2>", "<cmd>Telescope resume<CR>")
vim.keymap.set("n", "<leader>pf", "<cmd>lua RTELE(); require'telescope.builtin'.find_files{}<CR>")
vim.keymap.set(
    "n",
    "<leader>ps",
    "<cmd>lua RTELE(); require'telescope.builtin'.grep_string({ search = vim.fn.input('Grep For > ')})<CR>"
)
vim.keymap.set(
    "n",
    "<leader>pw",
    "<cmd>lua RTELE(); require'telescope.builtin'.grep_string({ search = vim.fn.expand('<cword>') })<CR>"
)
vim.keymap.set("n", "<leader>r", "<cmd>lua RTELE(); require'telescope.builtin'.lsp_references{}<CR>")
vim.keymap.set(
    "n",
    "<leader>ws",
    "<cmd>lua RTELE(); require'telescope.builtin'.lsp_workspace_symbols{ query = '*' }<CR>"
)
vim.keymap.set("n", "<leader>cs", "<cmd>lua RTELE(); require'telescope.builtin'.lsp_document_symbols{}<CR>")
vim.keymap.set(
    "n",
    "<leader>o",
    "<cmd>lua RTELE(); require'telescope.builtin'.lsp_document_symbols{ symbols = {'method', 'function', 'module', 'interface' } }<CR>"
)
vim.keymap.set("n", "<leader>gc", "<cmd>lua RTELE(); require'telescope.builtin'.git_branches{}<CR>")
