local colors = {
    bg = "#34343c",
    fg = "#c5cdd9",
    yellow = "#deb974",
    cyan = "#5dbbc1",
    darkblue = "#081633",
    green = "#a0c980",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#6cb6eb",
    red = "#ec7279",
    white = "#c5cdd9",
    lightgrey = "#57595e",
    darkgrey = "#404247",
}

require("nvim-gps").setup({})

local function min_window_width(width)
    return function()
        return vim.fn.winwidth(0) > width
    end
end

-- Customize statusline components
local custom_components = {
    -- Override 'encoding': Don't display if encoding is UTF-8.
    encoding = function()
        local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "") -- Note: '-' is a magic character
        return ret
    end,
    -- fileformat: Don't display if &ff is unix.
    fileformat = function()
        local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
        return ret
    end,
    -- GPS (https://github.com/SmiteshP/nvim-gps)
    treesitter_context = function()
        local ok, gps = pcall(require, "nvim-gps")
        if ok and gps.is_available() then
            return gps.get_location()
        end
        return ""
    end,
}

require("lualine").setup({
    options = {
        icons_enabled = true,
        always_divide_middle = true,
        theme = "nightfox",
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.darkgrey } },
    },
    sections = {
        lualine_a = {
            { "mode", right_padding = 2, cond = min_window_width(40) },
        },
        lualine_b = {
            { "filename", color = { gui = "bold" } },
            { "branch", color = { fg = colors.green, gui = "bold" }, cond = min_window_width(120) },
            {
                "diff",
                diff_color = {
                    added = { fg = colors.green, bg = colors.bg },
                    modified = { fg = colors.yellow, bg = colors.bg },
                    removed = { fg = colors.red, bg = colors.bg },
                },
            },
            { "diagnostics", sources = { "nvim_diagnostic" } },
        },
        lualine_c = {
            {
                custom_components.treesitter_context,
                color = { bg = colors.bg, fg = colors.blue, gui = "bold" },
            },
        },
        lualine_x = {},
        lualine_y = {
            { "location", cond = min_window_width(90) },
            "progress",
        },
        lualine_z = {
            "filesize",
            custom_components.fileformat,
            custom_components.encoding,
            { "filetype", icon_only = true, left_padding = 2 },
        },
    },
    inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
    },
    tabline = {},
    extensions = { "quickfix", "nvim-tree", "toggleterm", "symbols-outline" },
})
