-- Highlight on yank
vim.api.nvim_exec(
    [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
    false
)

local hb_utils = require("hb/utils")
local remap = hb_utils.remap
local opts = hb_utils.opt_noremap_silent

-- tab
remap("n", "]<tab>", "<cmd>tabnext<cr>", opts)
remap("n", "[<tab>", "<cmd>tabnext<cr>", opts)

vim.notify = require("notify")
vim.notify.setup()

-- bufferline
vim.o.termguicolors = true

require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp",
        sort_by = "directory",
        numbers = "buffer_id",
        show_buffer_close_icons = false,
        separator_style = "thin",
        offsets = { { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left" } },
    },
})
remap("n", "gb", "<cmd>BufferLinePick<CR>", { noremap = true, silent = true })
remap("n", "H", "<cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
remap("n", "L", "<cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })

-- nvim-bqf
require("bqf").setup({
    auto_enable = true,
    auto_resize_height = true,
    filter = {
        fzf = { action_for = { ["ctrl-s"] = "split" } },
        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
    },
})

vim.cmd([[
    hi BqfPreviewBorder guifg=#a0c980 ctermfg=71
    hi link BqfPreviewRange Search
]])

-- symbols-outline
vim.g.symbols_outline = {
    -- right, 25%, disable auto preview
    relative_width = true,
    width = 50,
    auto_preview = false,
    position = "right",
}

remap("n", "<leader>v", "<cmd>SymbolsOutline<CR>", opts)

-- indent_blankline
require("indent_blankline").setup({ show_current_context = true, show_current_context_start = true })

-- toggleterm
require("toggleterm").setup({
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
})

remap("n", "<c-q>", '<cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>', opts)
remap("i", "<c-q>", '<ESC><cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>', opts)
remap("t", "<c-q>", "<c-\\><c-n>:ToggleTerm direction=vertical<CR>", opts)

-- trouble.nvim mappings
remap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
remap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
remap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
remap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
remap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
remap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
