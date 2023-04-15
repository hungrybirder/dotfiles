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

local function min_window_width(width)
    return function()
        return vim.fn.winwidth(0) > width
    end
end

-- Override 'encoding': Don't display if encoding is UTF-8.
local function custom_encoding()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "") -- Note: '-' is a magic character
    return ret
end

-- fileformat: Don't display if &ff is unix.
local function custom_fileformat()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

local function custom_treesitter_context()
    local ok, navic = pcall(require, "nvim-navic")
    if ok and navic.is_available() then
        return navic.get_location()
    end
    return ""
end

-- https://github.com/nvim-lualine/lualine.nvim/issues/186#issuecomment-1170637440
vim.o.shortmess = vim.o.shortmess .. "S"
local function search_count()
    if vim.api.nvim_get_vvar("hlsearch") == 1 then
        local res = vim.fn.searchcount({ maxcount = 999, timeout = 500 })

        if res.total > 0 then
            return string.format("%d/%d", res.current, res.total)
        end
    end
    return ""
end

require("lualine").setup({
    options = {
        globalstatus = true,
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
            { search_count, type = "lua_expr" },
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
                custom_treesitter_context,
                color = { bg = colors.bg, fg = colors.blue, gui = "bold" },
            },
        },
        lualine_x = {},
        lualine_y = {
            {
                "location",
                cond = min_window_width(90),
                color = { fg = colors.blue, gui = "bold" },
            },
            {
                "progress",
                color = { fg = colors.blue, gui = "bold" },
            },
        },
        lualine_z = {
            { "filesize", color = { bg = colors.bg, fg = colors.blue } },
            custom_fileformat,
            custom_encoding,
            { "filetype", icon_only = true, left_padding = 2, color = { bg = colors.bg } },
        },
    },
    inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = { search_count },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
    },
    tabline = {},
    extensions = { "quickfix", "nvim-tree", "toggleterm", "symbols-outline" },
})
