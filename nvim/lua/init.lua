RELOAD = require('plenary.reload').reload_module
P = function(...) print(vim.inspect(...)) end

require('module/hb')
require('module/nvim-tree')
require('module/symbols-outline')
require('module/bufferline')
require('module/statusline')
require('module/neoscroll')
require('module/nvim-bqf')
require('module/telescope')
require('module/treesitter')
require('module/lsp')
require('module/efm')
require('module/nvim-cmp')
require('module/nvim-dap')
require('module/ultest')
-- require('module/lspsaga')
