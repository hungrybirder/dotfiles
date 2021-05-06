RELOAD = require('plenary.reload').reload_module
P = function(...) print(vim.inspect(...)) end

require('module/treesitter')
require('module/lsp')
require('module/telescope')
require('module/bubbly')

-- hb is a test.
require('module/hb')
