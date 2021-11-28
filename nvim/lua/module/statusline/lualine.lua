local colors = {
    bg = "#34343c",
    fg = "#c5cdd9",
    yellow = "#deb974",
    cyan = "#5dbbc1",
    darkblue = '#081633',
    green = "#a0c980",
    orange = '#FF8800',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = "#6cb6eb",
    red = "#ec7279",
    white = "#c5cdd9",
    lightgrey = "#57595e",
    darkgrey = "#404247"
}
require('lualine').setup {
    options = {
        icons_enabled = true,
        always_divide_middle = true,
        theme = 'material',
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.darkgrey } }
    },
    sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = {
            { 'filename', color = { gui = 'bold' } }, { 'branch', color = { fg = colors.green, gui = 'bold' } }, {
                'diff',
                diff_color = {
                    added = { fg = colors.green, bg = colors.bg },
                    modified = { fg = colors.yellow, bg = colors.bg },
                    removed = { fg = colors.red, bg = colors.bg }
                }
            }
        },
        lualine_c = {
            { 'b:lsp_current_function', color = { gui = 'bold', fg = colors.magenta, bg = colors.bg } },
            { 'diagnostics', sources = { 'nvim_lsp' } }
        },
        lualine_x = { 'lsp_progress' },
        lualine_y = { 'location', 'progress' },
        lualine_z = {
            'filesize', { 'fileformat', icons_enabled = false }, 'encoding',
            { 'filetype', icon_only = true, separator = { right = '' }, left_padding = 2 }
        }
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
    extensions = { 'quickfix', 'nvim-tree', 'toggleterm', 'symbols-outline' }
}
