require('lualine').setup {
    options = {
        icons_enabled = true,
        always_divide_middle = true,
        theme = 'material',
    },
    sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = { 'filename', 'branch', 'diff' },
        lualine_c = { { 'diagnostics', sources = { 'nvim_lsp' } } },
        lualine_x = { 'lsp_progress' },
        lualine_y = { 'location', 'progress' },
        lualine_z = { 'fileformat', 'encoding', { 'filetype', separator = { right = '' }, left_padding = 2 } }
    },
    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' }
    },
    tabline = {},
    extensions = { 'quickfix', 'nvim-tree', 'toggleterm', 'fugitive' }
}
