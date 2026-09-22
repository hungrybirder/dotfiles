return {
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme 是 LazyVim 的选项（不是 lazy.nvim 的），放这里才会生效
            colorscheme = "nightfox",
            defaults = {
                autocmds = true, -- lazyvim.config.autocmds
                keymaps = false, -- lazyvim.config.keymaps
            },
        },
    },
}
