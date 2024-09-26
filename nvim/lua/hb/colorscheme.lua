vim.cmd([[
try
  " colorscheme nightfox
  " colorscheme catppuccin
  colorscheme yorumi
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
]])
