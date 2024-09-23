vim.cmd([[
try
  " colorscheme nightfox
  colorscheme catppuccin
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
]])
