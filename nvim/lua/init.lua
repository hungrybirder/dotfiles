RELOAD = require('plenary.reload').reload_module
P = function(...) print(vim.inspect(...)) end

require('module/nvim-tree')
require('module/symbols-outline')
require('module/bufferline')
require('module/bubbly')
require('module/neoscroll')
require('module/nvim-bqf')
require('module/telescope')

require('module/treesitter')
require('module/lspsaga')
require('module/lsputils')
require('module/lsp')
-- require('module/nvim-compe')
require('module/nvim-cmp')

require('module/nvim-dap')
require('module/ultest')

-- hb is a test.
require('module/hb')
