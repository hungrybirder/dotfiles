local remap = vim.api.nvim_set_keymap

vim.api.nvim_command('set termguicolors')

require'bufferline'.setup{
  options={
    diagnostics = "nvim_lsp",
    sort_by="directory",
    numbers = "buffer_id",
    show_buffer_close_icons = false,
    separator_style = "thin",
    offsets = {{filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left"}},
    mappings = true,
  }
}

remap('n', 'gb', '<cmd>BufferLinePick<CR>', { noremap = true, silent = true,})

-- overrite vim-unimpaired ]b [b
remap('n', ']b', '<cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true,})
remap('n', '[b', '<cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true,})

