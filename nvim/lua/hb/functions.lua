local M = {}

M.toggle_number = function()
    if vim.o.number or vim.o.relativenumber then
        vim.o.number = false
        vim.o.relativenumber = false
        print("1 - > 0")
    else
        vim.o.number = true
        vim.o.relativenumber = true
        print("0 - > 1")
    end
end

return M
