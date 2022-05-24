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

-- tab
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "[<tab>", "<cmd>tabnext<cr>")

vim.notify = require("notify")
vim.notify.setup()

-- bufferline
vim.opt.termguicolors = true

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
vim.keymap.set("n", "gb", "<cmd>BufferLinePick<CR>")
vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<CR>")

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
    relative_width = true,
    auto_preview = false,
    position = "right",
}

vim.keymap.set("n", "<leader>v", "<cmd>SymbolsOutline<CR>")

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

vim.keymap.set("n", "<c-q>", '<cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
vim.keymap.set("i", "<c-q>", '<ESC><cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>:ToggleTerm direction=vertical<CR>")
vim.keymap.set("n", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
vim.keymap.set("i", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
vim.keymap.set("t", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')

-- trouble.nvim mappings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>")

-- Disable vim-dispatch mappings
vim.g.dispatch_no_maps = 1

-- litee
require("litee.lib").setup({
    on_open = "popout",
    panel = {
        orientation = "right",
        panel_size = 30,
    },
    tree = { icon_set = "codicons" },
})
require("litee.calltree").setup({})

-- modes
-- vim.opt.cursorline = true
-- require("modes").setup({})

-- j-hui/fidget.nvim
require("fidget").setup({})

-- zen-mode
require("zen-mode").setup({})

-- nvim-colorizer
require("colorizer").setup()

-- todo
require("todo-comments").setup({})

-- cmp_git
require("cmp_git").setup({})

-- trouble
require("trouble").setup({})

-- dressing
require("dressing").setup({})

-- which-key
-- require("which-key").setup({})
