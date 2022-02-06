M = {}

M.remap = vim.api.nvim_set_keymap
M.opt_noremap_silent = { noremap = true, silent = true }
M.opt_noremap = { noremap = true, silent = false }

return M
