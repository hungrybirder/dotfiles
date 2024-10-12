if vim.loader then
    vim.loader.enable()
end

P = vim.print

require("config.lazy")
