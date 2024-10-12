-- min window width
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

return {
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup({
                theme = "hyper",
            })
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },

    -- free writing
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            plugins = {
                gitsigns = true,
                tmux = true,
                kitty = { enabled = false, font = "+2" },
            },
        },
        keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                    icons_enabled = true,
                    always_divide_middle = true,
                    theme = "nightfox",
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            right_padding = 2,
                            cond = min_window_width(40),
                        },
                    },
                    lualine_b = {
                        { search_count, type = "lua_expr" },
                        { "filename" },
                        {
                            "branch",
                            cond = min_window_width(120),
                        },
                        {
                            "diff",
                            diff_color = {
                                added = {
                                    gui = "bold",
                                },
                                modified = {
                                    gui = "bold",
                                },
                                removed = {
                                    gui = "bold",
                                },
                            },
                        },
                    },
                    lualine_c = {
                        { "diagnostics", sources = { "nvim_diagnostic" } },
                        {
                            "aerial",
                            cond = min_window_width(40),
                            color = {
                                gui = "bold",
                                -- fg = colors.blue
                            },
                        },
                    },
                    lualine_x = {},
                    lualine_y = {
                        {
                            "location",
                            cond = min_window_width(90),
                        },
                        {
                            "progress",
                        },
                    },
                    lualine_z = {
                        custom_fileformat,
                        custom_encoding,
                        {
                            "filetype",
                            icon_only = true,
                            left_padding = 2,
                        },
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
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        enent = "VeryLazy",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "gb", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
            { "H", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
            { "L", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
        },
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                sort_by = "directory",
                numbers = "buffer_id",
                show_buffer_close_icons = false,
                separator_style = "thin",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
    },

    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 5000,
        },
    },

    -- icons
    {
        "echasnovski/mini.icons",
        version = false,
        opts = {},
        lazy = true,
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                -- needed since it will be false when loading and mini will fail
                package.loaded["nvim-web-devicons"] = {}
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
}
