vim.keymap.set("n", "<leader>ev", "<cmd>e $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>sv", "<cmd>so $MYVIMRC<CR>")

vim.keymap.set("n", "C", '"_C', { noremap = true })
vim.keymap.set("n", "D", '"_D', { noremap = true })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- inoremap maps a key combination for insert mode
-- <C-e> is the keybinding I am creating.
-- <C-o> is a command that switches vim to normal mode for one command.
-- $ jumps to the end of the line and we are switched back to insert mode.
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")

-- Best remap by ThePrimeagen
-- greatest remap ever
vim.keymap.set("v", "<leader>p", '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [[gg"+yG]])

-- Moving text
-- not pollute registers!
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
-- inoremap <C-k> <esc>:m .-2<CR>==
-- inoremap <C-j> <esc>:m .+1<CR>==
-- nnoremap <leader>j :m .+1<CR>==
-- nnoremap <leader>k :m .-2<CR>==

-- Switch to alternative buffer
vim.keymap.set("n", "<bs>", "<c-^>")

vim.keymap.set("n", "<C-c>", "<esc>")

-- Q: Closes the window
-- remap("n", "Q", "<cmd>q<CR>", opts)
vim.keymap.set("n", "Q", "<cmd>q<CR>")
-- Close all windows
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>")

-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")

-- Keeping it centered（n/N 的居中已并入 editor.lua 里 hlslens 的映射）
vim.keymap.set("n", "J", "mzJ`z")

-- Use alt + hjkl to resize windows
vim.keymap.set("n", "<M-j>", ":resize +2<CR>")
vim.keymap.set("n", "<M-k>", ":resize -2<CR>")
vim.keymap.set("n", "<M-h>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<M-l>", ":vertical resize -2<CR>")

-- jk 退出插入模式由 better-escape.nvim 提供

-- Move to window
-- <c-h/j/k/l> 由 vim-tmux-navigator 提供（tmux 外自动回退为 wincmd）
vim.keymap.set("n", "s<Left>", "<c-w>h", { desc = "Move to Left Split" })
vim.keymap.set("n", "s<Right>", "<cmd>wincmd l<CR>", { desc = "Move to Right Split" })
vim.keymap.set("n", "s<Up>", "<cmd>wincmd k<CR>", { desc = "Move to Up Split" })
vim.keymap.set("n", "s<Down>", "<cmd>wincmd j<CR>", { desc = "Move to Down Split" })

-- Split window
vim.keymap.set("n", "|", "<cmd>vsp<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "sv", "<cmd>vsp<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "sh", "<cmd>sp<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "sc", "<c-w>c", { desc = "Close Current Split" })
vim.keymap.set("n", "so", "<c-w>o", { desc = "Close Other Split" })

--
-- ctrl_e ctrl_y 3 lines
vim.keymap.set("n", "<c-e>", "3<c-e>")
vim.keymap.set("n", "<c-y>", "3<c-y>")
vim.keymap.set("v", "<c-e>", "3<c-e>")
vim.keymap.set("v", "<c-y>", "3<c-y>")

-- vim.keymap.set("n", "<esc><esc>", "<cmd>nohlsearch<CR>")

-- vim.keymap.set("n", "<leader>N", "<cmd>lua require('hb/functions').toggle_number()<CR>")

-- tmuxjump
vim.g.tmuxjump_telescope = 1
vim.keymap.set("n", "<leader>ft", "<cmd>TmuxJumpFile<CR>")

-- Reselect pasted text
-- From https://vimtricks.com/p/reselect-pasted-text/
vim.keymap.set("n", "gp", "`[v`]")

-- folder mappings
-- vim.keymap.set("n", "<leader>z", ":call ToggleFold()<CR>")

-- Naviagting in command mode
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<Esc>b", "<S-Left>")
vim.keymap.set("c", "<Esc>f", "<S-Right>")

-- in( / il( / in[ ... 由 LazyVim 自带的 mini.ai 提供（in = inside next, il = inside last）

vim.keymap.set({ "n", "i" }, "<F1>", "<nop>")

-- tab
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>")

vim.api.nvim_create_user_command("ToggleLspDiagnostic", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle LSP diagnostics" })

-- for neo-tree
vim.keymap.set("n", "<leader><tab>", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
