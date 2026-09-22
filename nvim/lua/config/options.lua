-- 只保留与 LazyVim / Neovim 默认值不同的选项，其余由 lazyvim.config.options 提供
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.title = true
vim.opt.exrc = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.scrolloff = 8
vim.opt.cmdheight = 1

-- nvim-ufo
vim.opt.foldcolumn = "1"
vim.opt.foldlevelstart = 99
