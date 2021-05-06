RELOAD = require('plenary.reload').reload_module
P = function(...) print(vim.inspect(...)) end

require('module/treesitter')
require('module/lsp')
require('module/telescope')
require('module/bubbly')
require('module/nvim-tree')

-- hb is a test.
require('module/hb')
