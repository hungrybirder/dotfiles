RELOAD = require("plenary.reload").reload_module
RTELE = function()
    RELOAD "hb.telescope"
    RELOAD "telescope"
end

P = function(...)
    print(vim.inspect(...))
end

require "hb/misc"
require "hb/git"
require "hb/nvim-tree"
require "hb/statusline"
require "hb/telescope"
require "hb/treesitter"
require "hb/lsp"
require "hb/compe"
require "hb/dap"
require "hb/ultest"
