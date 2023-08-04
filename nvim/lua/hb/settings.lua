vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.relativenumber = true

vim.o.timeout = true
vim.o.ttimeout = true
vim.o.timeoutlen = 500 -- Time out on mappings
vim.o.updatetime = 100 -- Idle time to write swap and trigger CursorHold
vim.o.ttimeoutlen = 10 -- Time out on key codes

vim.o.exrc = true
vim.o.hidden = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true
vim.o.wrap = false

vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undodir = os.getenv("HOME") .. "/.config/nvim_undir"
vim.o.undofile = true

vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.showmode = false

vim.o.signcolumn = "yes"

vim.o.completeopt = "menu,menuone,noselect"
vim.o.mouse = ""

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.cmdheight = 1
vim.o.shortmess = "filnxtToOFSc"

----------

vim.keymap.set("n", "<leader>ev", "<cmd>e $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>sv", "<cmd>so $MYVIMRC<CR>")

-- Best remap by ThePrimeagen
-- greatest remap ever
vim.keymap.set("v", "<leader>p", '"_dP')

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- inoremap maps a key combination for insert mode
-- <C-e> is the keybinding I am creating.
-- <C-o> is a command that switches vim to normal mode for one command.
-- $ jumps to the end of the line and we are switched back to insert mode.
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", 'gg"+yG')

-- Behave Vim
vim.keymap.set("n", "Y", "y$")

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
-- close all windows
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>")

-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")

-- Keeping it centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")

-- Use alt + hjkl to resize windows
vim.keymap.set("n", "<M-j>", ":resize +2<CR>")
vim.keymap.set("n", "<M-k>", ":resize -2<CR>")
vim.keymap.set("n", "<M-h>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<M-l>", ":vertical resize -2<CR>")

-- delete current line
-- map <c-d> dd
-- delete current line in Insert Mode
-- imap <c-d> <esc>ddi
-- exit insert mode
-- inoremap jk <esc>
vim.keymap.set("i", "jk", "<esc>")

-- Move to window
vim.keymap.set("n", "<c-h>", "<cmd>wincmd h<CR>")
vim.keymap.set("n", "<c-j>", "<cmd>wincmd j<CR>")
vim.keymap.set("n", "<c-k>", "<cmd>wincmd k<CR>")
vim.keymap.set("n", "<c-l>", "<cmd>wincmd l<CR>")
--
-- ctrl_e ctrl_y 3 lines
vim.keymap.set("n", "<c-e>", "3<c-e>")
vim.keymap.set("n", "<c-y>", "3<c-y>")
vim.keymap.set("v", "<c-e>", "3<c-e>")
vim.keymap.set("v", "<c-y>", "3<c-y>")

vim.keymap.set("n", "<esc><esc>", "<cmd>nohlsearch<CR>")

-- map toggle number
vim.keymap.set("n", "<leader>N", "<cmd>call ToggleNumber()<CR>")

-- tmuxjump
vim.g.tmuxjump_telescope = 1
vim.keymap.set("n", "<leader>ft", "<cmd>TmuxJumpFile<CR>")

-- Reselect pasted text
-- From https://vimtricks.com/p/reselect-pasted-text/
vim.keymap.set("n", "gp", "`[v`]")

-- folder mappings
vim.keymap.set("n", "<leader>z", ":call ToggleFold()<CR>")
vim.keymap.set("n", "<s-tab>", "za")

-- Naviagting in command mode
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<Esc>b", "<S-Left>")
vim.keymap.set("c", "<Esc>f", "<S-Right>")

-- 更新括号里的内容，非常有用
vim.keymap.set("o", "in(", ":<c-u>normal! f(vi(<cr>")
vim.keymap.set("o", "il(", " :<c-u>normal! F)vi(<cr>")
vim.keymap.set("o", "in[", " :<c-u>normal! f[vi[<cr>")
vim.keymap.set("o", "il[", " :<c-u>normal! F]vi[<cr>")
vim.keymap.set("o", "in<", " :<c-u>normal! f<vi<<cr>")
vim.keymap.set("o", "il<", " :<c-u>normal! F>vi<<cr>")

vim.keymap.set({ "n", "i" }, "<F1>", "<nop>")
