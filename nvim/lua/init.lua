RELOAD = require('plenary.reload').reload_module
P = function(...) print(vim.inspect(...)) end

require('module/treesitter')
require('module/lsp')
require('module/telescope')

-- hb is a test.
require('module/hb')
