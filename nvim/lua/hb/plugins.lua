---@diagnostic disable: missing-fields

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local lazy_options = {
    ui = {
        size = { width = 1.0, height = 1.0 },
    },
    diff = {
        cmd = "diffview.nvim",
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
}

vim.keymap.set("n", "<leader>pu", "<cmd>Lazy sync<CR>")

require("lazy").setup({
    {
        "leath-dub/snipe.nvim",
        keys = {
            {
                "<leader>b",
                function()
                    require("snipe").open_buffer_menu()
                end,
                desc = "Open Snipe buffer menu",
            },
        },
        opts = {
            ui = {
                position = "center",
            },
        },
    },
    {
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup()
        end,
    },
    -- {
    --     "folke/which-key.nvim",
    --     event = "VeryLazy",
    --     init = function()
    --         vim.o.timeout = true
    --         vim.o.timeoutlen = 300
    --     end,
    -- },
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
    -- TODO: task runner
    -- {
    --     "stevearc/overseer.nvim",
    --     config = function()
    --         require("overseer").setup({
    --             strategy = "toggleterm",
    --         })
    --         require("dap.ext.vscode").json_decode = require("overseer.json").decode
    --     end,
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         "akinsho/toggleterm.nvim",
    --     },
    -- },
    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require("notify")
            notify.setup({})
            vim.notify = notify
        end,
    },
    { "hotoo/pangu.vim" },
    {
        "airblade/vim-rooter",
        config = function()
            vim.g.root_patterns = {
                ".git",
                "_darcs",
                ".hg",
                ".bzr",
                ".svn",
                "Makefile",
                "package.json",
                "tox.ini",
                "pom.xml",
            }
            vim.g.rooter_cd_cmd = "lcd"
            vim.g.rooter_silent_chdir = 1
            vim.g.rooter_resolve_links = 1
        end,
    },
    { "jamessan/vim-gnupg" },
    -- buffer line at the top of window
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.opt.termguicolors = true
            vim.keymap.set("n", "gb", "<cmd>BufferLinePick<CR>")
            vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<CR>")
            vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<CR>")

            require("bufferline").setup({
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
            })
        end,
    },
    -- delete buffer without closing windows
    {
        "moll/vim-bbye",
        keys = {
            { "<leader><BS>", "<cmd>Bdelete<CR>" },
        },
    },

    -- Delete all the buffers except the current buffer
    { "schickling/vim-bufonly" },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("hb/statusline")
        end,
    },
    {
        "rhysd/clever-f.vim",
        keys = {
            { ";", "<Plug>(clever-f-repeat-forward)" },
            { ",", "<Plug>(clever-f-repeat-back)" },
        },
    },
    {
        "andymass/vim-matchup",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    -- FIX:
    -- FIXME:
    -- TODO:
    -- PERF:
    -- HACK:
    -- INFO:
    -- WARNING:
    -- NOTE:
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({})
        end,
    },

    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({ calm_down = true })
            vim.cmd([[
                aug VMlens
                    au!
                    au User visual_multi_start lua require("hb/vmlens").start()
                    au User visual_multi_exit lua require("hb/vmlens").exit()
                aug END
            ]])
            local kopts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap(
                "n",
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap(
                "n",
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

            -- vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
        end,
    },
    -- powered by tpope
    { "tpope/vim-repeat" },
    { "tpope/vim-speeddating" },
    { "tpope/vim-unimpaired" },
    -- { "tpope/vim-commentary" },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
        lazy = false,
    },
    -- save my last cursor position
    {
        "farmergreg/vim-lastplace",
        config = function()
            vim.g.lastplace_ignore = "gitcommit, gitrebase, svn, hgcommit, mason"
            vim.g.lastplace_ignore_buftype = "quickfix, nofile, help"
            vim.g.lastplace_open_folds = 1
        end,
    },
    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({})
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
    -- {
    --     "folke/styler.nvim",
    --     config = function()
    --         require("styler").setup({
    --             themes = {
    --                 markdown = { colorscheme = "catppuccin-mocha", background = "dark" },
    --                 help = { colorscheme = "catppuccin-mocha", background = "dark" },
    --             },
    --         })
    --     end,
    --     dependencies = {
    --         {
    --             "catppuccin/nvim",
    --             name = "catppuccin",
    --         },
    --         { "EdenEast/nightfox.nvim" },
    --     },
    -- },
    { "EdenEast/nightfox.nvim" },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- speedup editing friendly
    { "szw/vim-maximizer" },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        config = function()
            vim.g["VM_leader"] = "\\"
        end,
    },
    {
        "Pocco81/HighStr.nvim",
        config = function()
            local high_str = require("high-str")
            high_str.setup({
                verbosity = 0,
                saving_path = "/tmp/highstr/",
                highlight_colors = {
                    -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
                    color_0 = { "#0c0d0e", "smart" }, -- Cosmic charcoal
                    color_1 = { "#e5c07b", "smart" }, -- Pastel yellow
                    color_2 = { "#7FFFD4", "smart" }, -- Aqua menthe
                    color_3 = { "#8A2BE2", "smart" }, -- Proton purple
                    color_4 = { "#FF4500", "smart" }, -- Orange red
                    color_5 = { "#008000", "smart" }, -- Office green
                    color_6 = { "#0000FF", "smart" }, -- Just blue
                    color_7 = { "#FFC0CB", "smart" }, -- Blush pink
                    color_8 = { "#FFF9E3", "smart" }, -- Cosmic latte
                    color_9 = { "#7d5c34", "smart" }, -- Fallow brown
                },
            })
            vim.keymap.set("v", "<F6>", ":<c-u>HSHighlight 1<CR>")
            vim.keymap.set("v", "<F7>", ":<c-u>HSRmHighlight<CR>")
        end,
    },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },

    -- git
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                default_args = {
                    DiffviewOpen = { "--imply-local" },
                },
                keymaps = {
                    file_panel = {
                        {
                            "n",
                            "cc",
                            "<Cmd>Git commit <bar> wincmd J<CR>",
                            { desc = "Commit staged changes" },
                        },
                        -- {
                        --     "n",
                        --     "ca",
                        --     "<Cmd>Git commit --amend <bar> wincmd J<CR>",
                        --     { desc = "Amend the last commit" },
                        -- },
                        -- {
                        --     "n",
                        --     "c<space>",
                        --     ":Git commit ",
                        --     { desc = 'Populate command line with ":Git commit "' },
                        -- },
                    },
                },
            })
        end,
        keys = {
            { "<leader>vc", "<cmd>DiffviewClose<CR>" },
            { "<leader>vo", "<cmd>DiffviewOpen<CR>" },
            { "<leader>vr", "<cmd>DiffviewRefresh<CR>" },
            { "<leader>vt", "<cmd>DiffviewToggleFiles<CR>" },
            { "<leader>vf", "<cmd>DiffviewFocusFiles<CR>" },
        },
        lazy = false,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
        config = function()
            require("neogit").setup({
                mappings = {
                    finder = {
                        ["<c-j>"] = "Next",
                        ["<c-k>"] = "Previous",
                    },
                    status = {
                        ["<esc>"] = "Close",
                    },
                },
            })
            vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")
            vim.keymap.set("n", "<leader>gv", "<cmd>lua require('neogit').open({'log'})<cr>")
        end,
    },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gh", "<cmd>diffget //2<CR>")
            vim.keymap.set("n", "<leader>gf", "<cmd>diffget //3<CR>")
            vim.keymap.set("n", "<leader>gs", "<cmd>G<CR>")
            vim.keymap.set("n", "<leader>ga", "<cmd>Git fetch --all<CR>")
        end,
    },
    -- { "junegunn/gv.vim" },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    -- Actions
                    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
                    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
                    map("n", "<leader>hS", gs.stage_buffer)
                    map("n", "<leader>hu", gs.undo_stage_hunk)
                    map("n", "<leader>hR", gs.reset_buffer)
                    map("n", "<leader>hp", gs.preview_hunk)
                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end)
                    map("n", "<leader>tb", gs.toggle_current_line_blame)
                    map("n", "<leader>hd", gs.diffthis)
                    map("n", "<leader>hD", function()
                        gs.diffthis("~")
                    end)
                    map("n", "<leader>td", gs.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    },
    {
        "ruifm/gitlinker.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("gitlinker").setup({})
        end,
    },

    -- powered by svermeulen
    {
        "svermeulen/vim-subversive",
        config = function()
            -- s for substitue
            vim.keymap.set("n", "s", "<plug>(SubversiveSubstitute)", { noremap = true, silent = true })
            vim.keymap.set("n", "ss", "<plug>(SubversiveSubstituteLine)", { noremap = true, silent = true })
            vim.keymap.set("n", "S", "<plug>(SubversiveSubstituteToEndOfLine)", { noremap = true, silent = true })
            -- <leader>s<motion1><motion2>
            -- vim.keymap.set({ "n", "x" }, "<leader>s", "<plug>(SubversiveSubstituteRange)", { noremap = true })
            -- vim.keymap.set("n", "<leader>ss", "<plug>(SubversiveSubstituteWordRange)", { noremap = true })
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                char = {
                    jump_labels = true,
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
    -- {
    --     "svermeulen/vim-yoink",
    --     config = function()
    --         vim.keymap.set("n", "[y", "<plug>(YoinkRotateBack)")
    --         vim.keymap.set("n", "]y", "<plug>(YoinkRotateForward)")
    --     end,
    -- },

    {
        "stevearc/stickybuf.nvim",
        opts = {},
    },
    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.cmd(
                [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
            )
            vim.keymap.set("n", "<leader><tab>", "<cmd>NvimTreeToggle<CR>")
            local function nvim_tree_on_attach(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "<c-v>", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
                vim.keymap.set("n", "<c-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
                vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
            end
            require("nvim-tree").setup({
                on_attach = nvim_tree_on_attach,
                disable_netrw = false,
                create_in_closed_folder = false,
                hijack_netrw = true,
                open_on_tab = false,
                hijack_cursor = false,
                update_cwd = false,
                diagnostics = { enable = true },
                update_focused_file = {
                    -- enable = false,
                    enable = true,
                    update_cwd = false,
                    ignore_list = {},
                },
                view = {
                    width = 30,
                    side = "left",
                    -- mappings = {
                    --     custom_only = false,
                    --     list = {
                    --         { key = "<C-e>", action = "" }, -- disable edit_in_place
                    --     },
                    -- },
                },
                filters = {
                    dotfiles = false,
                    -- ignore some dirs
                    custom = { ".git", "node_modules", ".cache" },
                },
                renderer = {
                    highlight_opened_files = "all",
                },
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        opts = {
            keymaps = {
                ["<ESC>"] = "actions.close",
            },
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    {
        "Bekaboo/dropbar.nvim",
        -- optional, but required for fuzzy finder support
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },

    -- {
    --     "pwntester/octo.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     config = function()
    --         require("octo").setup({})
    --     end,
    -- },
    -- lsp config
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
                registries = {
                    "github:nvim-java/mason-registry",
                    "github:mason-org/mason-registry",
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
                    "rust_analyzer",
                    "pyright",
                    "ruff",
                    "gopls",
                    "vimls",
                    "bashls",
                    "lua_ls",
                    "ansiblels",
                    "yamlls",
                },
            })
        end,
    },
    { "neovim/nvim-lspconfig" },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- progress = {
            --     suppress_on_insert = true,
            --     ignore_done_already = true,
            --     ignore_empty_message = true,
        },
    },
    -- IncRename
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup({
                input_buffer_type = "dressing",
            })
        end,
        keys = {
            { "<leader>rn", ":IncRename " },
        },
    },
    {
        "felpafel/inlay-hint.nvim",
        event = "LspAttach",
        config = function()
            require("inlay-hint").setup({
                virt_text_pos = "inline",
            })
            vim.lsp.inlay_hint.enable(true)
            -- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            --     callback = function()
            --         vim.lsp.inlay_hint.enable(true)
            --     end,
            -- })
            -- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            --     callback = function()
            --         vim.lsp.inlay_hint.enable(false)
            --     end,
            -- })
        end,
    },

    -- lsp for performance UI.

    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            -- vim.keymap.set("n", "<leader>v", "<cmd>Lspsaga outline<CR>")
            require("lspsaga").setup({
                diagnostic = {
                    show_code_action = true,
                    show_layout = "float",
                    show_normal_height = 10,
                    jump_num_shortcut = true,
                    max_width = 0.8,
                    max_height = 0.6,
                    max_show_width = 0.9,
                    max_show_height = 0.6,
                    text_hl_follow = true,
                    border_follow = true,
                    extend_relatedInformation = false,
                    diagnostic_only_current = false,
                    keys = {
                        exec_action = "o",
                        quit = "q",
                        toggle_or_jump = "<CR>",
                        quit_in_show = { "q", "<ESC>" },
                    },
                },
                code_action = {
                    keys = {
                        quit = { "q", "<ESC>" },
                        exec = "<CR>",
                    },
                },
                outline = {
                    win_position = "right",
                    win_width = 33,
                    auto_preview = false,
                    detail = true,
                    auto_close = true,
                    close_after_jump = false,
                    layout = "normal",
                    max_height = 0.5,
                    left_width = 0.3,
                    keys = {
                        toggle_or_jump = { "<CR>", "o" },
                        quit = { "q", "<ESC>" },
                        jump = "e",
                    },
                },
                lightbulb = {
                    enable = false,
                    enable_in_insert = false,
                    -- sign = true,
                    -- sign_priority = 40,
                    -- virtual_text = true,
                },
                callhierarchy = {
                    show_detail = false,
                    keys = {
                        edit = { "e", "<CR>" },
                        vsplit = "v",
                        split = "s",
                        tabe = "t",
                        jump = "o",
                        quit = { "q", "<ESC>" },
                        expand_collapse = "u",
                    },
                },
                beacon = { --winbar
                    enable = false,
                    -- enable = true,
                    -- frequency = 7,
                },
                finder = {
                    max_height = 0.5,
                    left_width = 0.5,
                    right_width = 0.6,
                    methods = {},
                    default = "ref+imp",
                    layout = "float",
                    silent = false,
                    filter = {},
                    sp_inexist = false,
                    keys = {
                        shuttle = "[w",
                        toggle_or_open = { "o", "<CR>" },
                        vsplit = "s",
                        split = "i",
                        tabe = "t",
                        tabnew = "r",
                        quit = { "q", "<ESC>" },
                        close = "<c-c>k",
                    },
                },
            })
            vim.api.nvim_create_augroup("lspsaga_filetypes", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = "lspsaga_filetypes",
                pattern = {
                    "LspsagaCodeAction",
                    "LspsagaDiagnostic",
                    "LspsagaFinder",
                    "LspsagaFloaterm",
                    "LspsagaHover",
                    "LspsagaRename",
                    "LspsagaSignatureHelp",
                },
                callback = function()
                    vim.api.nvim_set_keymap("n", "<ESC>", "<cmd>close!<CR>", {
                        buffer = true,
                        nowait = true,
                        silent = true,
                    })
                end,
            })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" },
        },
    },
    {
        "stevearc/aerial.nvim",
        opts = {
            on_attach = function(bufnr)
                -- Jump forwards/backwards with '{' and '}'
                vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end,
            keymaps = {
                ["<ESC>"] = "actions.close",
            },
            layout = {
                max_width = { 40, 0.3 },
                min_width = { 25, 0.2 },
                default_direction = "prefer_right",
            },
            autojump = false,
        },
        keys = {
            { "<leader>v", "<cmd>AerialToggle!<CR>" },
            -- { "<leader>ds", "<cmd>call aerial#fzf()<CR>" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },

    -- snippets
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            {
                "petertriho/cmp-git",
                dependencies = "nvim-lua/plenary.nvim",
                config = function()
                    require("cmp_git").setup({})
                end,
            },
            "davidsierradz/cmp-conventionalcommits",
            { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
            "Snikimonkd/cmp-go-pkgs",
        },
        config = function()
            require("hb/compe")
        end,
        event = "InsertEnter",
    },

    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                mode = "document_diagnostics",
                use_diagnostic_signs = true,
            })
            vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
            vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
            vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
            vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
            vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
            vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>")
            -- Disable vim-dispatch mappings
            vim.g.dispatch_no_maps = 1
        end,
    },
    {
        "dgagn/diagflow.nvim",
        event = "LspAttach",
        opts = {},
    },

    -- nvim-autopairs can set up <CR>
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}, -- this is equalent to setup({}) function
    },

    -- tree sitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-refactor",
            "RRethy/nvim-treesitter-endwise",
            "theprimeagen/jvim.nvim", -- for json
        },
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "go",
                    "gomod",
                    "java",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "mermaid",
                    "python",
                    "regex",
                    "rust",
                    "typescript",
                    "vim",
                    "vimdoc",
                },
                indent = { enable = false },
                highlight = {
                    enable = true,
                    -- Disable slow treesitter highlight for large files
                    disable = function(_, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<cr>",
                        node_incremental = "<cr>",
                        node_decremental = "<tab>",
                        scope_incremental = "<s-cr>",
                    },
                },
                refactor = {
                    highlight_definitions = { enable = false },
                    highlight_current_scope = { enable = false },
                    smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
                    navigation = {
                        enable = true,
                        keymaps = {
                            goto_definition = "gnd",
                            list_definitions = "gnD",
                            list_definitions_toc = "gO",
                            goto_next_usage = "<a-*>",
                            goto_previous_usage = "<a-#>",
                        },
                    },
                },
                -- nvim-treesitter/nvim-treesitter-textobjects
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["ie"] = "@block.inner",
                            ["ae"] = "@block.outer",
                            ["im"] = "@call.inner",
                            ["am"] = "@call.outer",
                            ["if"] = "@function.inner",
                            ["af"] = "@function.outer",
                            ["iC"] = "@class.inner",
                            ["aC"] = "@class.outer",
                            ["ic"] = "@conditional.inner",
                            ["ac"] = "@conditional.outer",
                            ["il"] = "@loop.inner",
                            ["al"] = "@loop.outer",
                            ["is"] = "@parameter.inner",
                            ["as"] = "@statement.outer",
                            ["ad"] = "@comment.outer",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        peek_definition_code = {
                            ["<leader>df"] = "@function.outer",
                            ["<leader>dF"] = "@class.outer",
                        },
                    },
                    move = {
                        enable = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sn"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>sp"] = "@parameter.inner",
                        },
                    },
                },
                playground = {
                    enable = true,
                    -- disable = {},
                    updatetime = 25,
                    persist_queries = false,
                },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },
                matchup = { enable = true },
                autopairs = { enable = true },
                endwise = { enable = true },
            })
        end,
    },

    -- code injections
    {
        "Dronakurl/injectme.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        -- This is for lazy load and more performance on startup only
        cmd = { "InjectmeToggle", "InjectmeSave", "InjectmeInfo", "InjectmeLeave" },
        config = function()
            require("injectme").setup({
                -- mode = "standard",
                mode = "standard",
                -- "all"/ "none" if all/no injections should be activated on startup
                --    When you use, lazy loading, call :InjectemeInfo to activate
                -- "standard", if no injections should be changed from standard settings in
                --    the runtime directory, i.e. ~/.config/nvim/queries/<language>/injections.scm
                reload_all_buffers = true,
                -- after toggling an injection, all buffers are reloaded to reset treesitter
                -- you can set this to false, and avoid that the plugin asks you to save buffers
                -- before changing an injection
                reset_treesitter = true,
                -- after toggling an injections, the treesitter parser is reset
                -- Currently, this does nothing, see this discussion on github
                -- https://github.com/nvim-treesitter/nvim-treesitter/discussions/5684
            })
        end,
    },
    -- best folder plugin nvim-ufo
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            {
                                text = { builtin.foldfunc },
                                click = "v:lua.ScFa",
                            },
                            {
                                text = { "%s" },
                                click = "v:lua.ScSa",
                            },
                            {
                                text = { builtin.lnumfunc, " " },
                                click = "v:lua.ScLa",
                            },
                        },
                    })
                end,
            },
        },
        config = function()
            require("ufo").setup({
                preview = {
                    mappings = {
                        close = "<ESC>",
                    },
                },
                fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                    local newVirtText = {}
                    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
                    local sufWidth = vim.fn.strdisplaywidth(suffix)
                    local targetWidth = width - sufWidth
                    local curWidth = 0
                    for _, chunk in ipairs(virtText) do
                        local chunkText = chunk[1]
                        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if targetWidth > curWidth + chunkWidth then
                            table.insert(newVirtText, chunk)
                        else
                            chunkText = truncate(chunkText, targetWidth - curWidth)
                            local hlGroup = chunk[2]
                            table.insert(newVirtText, { chunkText, hlGroup })
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            -- str width returned from truncate() may less than 2nd argument, need padding
                            if curWidth + chunkWidth < targetWidth then
                                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, { suffix, "MoreMsg" })
                    return newVirtText
                end,
            })
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
            vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
            vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
            vim.keymap.set("n", "<s-tab>", "za")
        end,
    },
    -- better quickfix window
    {
        "kevinhwang91/nvim-bqf",
        dependencies = {
            {
                "junegunn/fzf",
                build = function()
                    vim.fn["fzf#install"]()
                end,
            },
        },
        config = function()
            require("bqf").setup({
                auto_enable = true,
                auto_resize_height = true,
                filter = {
                    fzf = { action_for = { ["ctrl-s"] = "split" } },
                    extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                },
            })
            vim.cmd([[
                hi BqfPreviewBorder guifg=#a0c980 ctermfg=71
                hi link BqfPreviewRange Search
            ]])
        end,
    },

    -- mx              Set mark x
    -- m,              Set the next available alphabetical (lowercase) mark
    -- m;              Toggle the next available mark at the current line
    -- dmx             Delete mark x
    -- dm-             Delete all marks on the current line
    -- dm<space>       Delete all marks in the current buffer
    -- m]              Move to next mark
    -- m[              Move to previous mark
    -- m:              Preview mark. This will prompt you for a specific mark to
    --                 preview; press <cr> to preview the next mark.
    --
    -- m[0-9]          Add a bookmark from bookmark group[0-9].
    -- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
    -- m}              Move to the next bookmark having the same type as the bookmark under
    --                 the cursor. Works across buffers.
    -- m{              Move to the previous bookmark having the same type as the bookmark under
    --                 the cursor. Works across buffers.
    -- dm=             Delete the bookmark under the cursor.
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup()
        end,
    },

    -- registers
    { "tversteeg/registers.nvim" },

    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("hb/telescope")
        end,
    },
    { "nvim-telescope/telescope-dap.nvim" },

    -- coding utils
    { "Valloric/ListToggle" },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local code_actions = null_ls.builtins.code_actions
            local diagnostics = null_ls.builtins.diagnostics
            null_ls.setup({
                debug = false,
                sources = {
                    formatting.stylua,
                    formatting.remark,
                    formatting.shfmt,
                    -- formatting.black,
                    -- formatting.trim_whitespace, -- TODO: use editorconfig
                    formatting.goimports,
                    -- formatting.gofmt,
                    -- formatting.rustfmt, -- TODO: use rust_analyzer
                    formatting.clang_format.with({
                        filetypes = { "c", "cpp" },
                    }),
                    formatting.sql_formatter,
                    -- formatting.google_java_format,
                    -- formatting.protolint,
                    -- formatting.yamlfmt,
                    -- formatting.beautysh, -- TODO: use shfmt
                    formatting.prettier.with({
                        filetypes = { "javascript", "typescript" },
                    }),
                    -- formatting.xmlformat, -- TODO: use lemminx

                    diagnostics.golangci_lint,
                    -- diagnostics.pylint,
                    diagnostics.ansiblelint,

                    -- code_actions for git
                    code_actions.gitsigns,
                    code_actions.gitrebase,

                    -- code_action for go
                    code_actions.impl,
                    code_actions.gomodifytags,
                },
                on_attach = function(client)
                    if client.supports_method("textDocument/formatting") then
                        vim.cmd([[
                            augroup LspFormatting
                                autocmd! * <buffer>
                                autocmd BufWritePost <buffer> lua vim.lsp.buf.format({ async=false })
                            augroup END
                        ]])
                    end
                end,
            })
            null_ls.register(require("none-ls-shellcheck.diagnostics"))
            null_ls.register(require("none-ls-shellcheck.code_actions"))
            null_ls.register(require("none-ls-luacheck.diagnostics.luacheck"))
        end,
        dependencies = {
            "gbprod/none-ls-shellcheck.nvim",
            "gbprod/none-ls-luacheck.nvim",
        },
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "Wansmer/treesj",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "AndrewRadev/splitjoin.vim",
        },
        config = function()
            require("treesj").setup({
                use_default_keymaps = false,
                max_join_length = 120,
            })
            local langs = require("treesj.langs")["presets"]

            vim.api.nvim_create_autocmd({ "FileType" }, {
                pattern = "*",
                callback = function()
                    local opts = { buffer = true }
                    if langs[vim.bo.filetype] then
                        vim.keymap.set("n", "gS", "<Cmd>TSJSplit<CR>", opts)
                        vim.keymap.set("n", "gJ", "<Cmd>TSJJoin<CR>", opts)
                    else
                        vim.keymap.set("n", "gS", "<Cmd>SplitjoinSplit<CR>", opts)
                        vim.keymap.set("n", "gJ", "<Cmd>SplitjoinJoin<CR>", opts)
                    end
                end,
            })
        end,
    },
    --     "lukas-reineke/indent-blankline.nvim",
    --     main = "ibl",
    --     config = function()
    --         require("ibl").setup({
    --             exclude = {
    --                 filetypes = {
    --                     "vim",
    --                     "lua",
    --                     "python",
    --                     "dashboard",
    --                     "go",
    --                     "java",
    --                 },
    --             },
    --         })
    --     end,
    -- },

    -- dev languages
    {
        "hat0uma/prelive.nvim",
        opts = {},
        cmd = {
            "PreLiveGo",
            "PreLiveStatus",
            "PreLiveClose",
            "PreLiveCloseAll",
            "PreLiveLog",
        },
    },
    -- for js/ts dev
    {
        "barrett-ruth/live-server.nvim",
        build = "pnpm add -g live-server",
        cmd = { "LiveServerStart", "LiveServerStop" },
        config = true,
    },
    -- for rust dev
    { "rust-lang/rust.vim" },
    { "simrat39/rust-tools.nvim" },
    {
        "saecki/crates.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    },

    -- for Go dev
    -- Alternate between files, such as foo.go and foo_test.go
    {
        "rgroli/other.nvim",
        config = function()
            require("other-nvim").setup({
                mappings = {
                    {
                        pattern = "(.*).go$",
                        target = "%1_test.go",
                        context = "test",
                    },
                    {
                        pattern = "(.*)_test.go$",
                        target = "%1.go",
                        context = "file",
                    },
                },
            })

            vim.api.nvim_create_user_command("A", function(opts)
                require("other-nvim").open(opts.fargs[1])
            end, { nargs = "*" })

            vim.api.nvim_create_user_command("AV", function(opts)
                require("other-nvim").openVSplit(opts.fargs[1])
            end, { nargs = "*" })

            vim.api.nvim_create_user_command("AS", function(opts)
                require("other-nvim").openSplit(opts.fargs[1])
            end, { nargs = "*" })
        end,
    },
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                lsp_inlay_hints = {
                    enable = false,
                },
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },

    -- for lua develop
    {
        "folke/neoconf.nvim",
        config = function()
            require("neoconf").setup({})
        end,
    },
    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                library = {
                    plugins = { "nvim-dap-ui" },
                    types = true,
                },
            })
        end,
    },

    -- for Java dev
    { "mfussenegger/nvim-jdtls" },

    -- markdown
    { "qadzek/link.vim" },
    {
        "MeanderingProgrammer/markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("render-markdown").setup({})
        end,
    },
    -- {
    --     "lukas-reineke/headlines.nvim",
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     opts = {},
    -- },
    { "mzlogin/vim-markdown-toc" },
    {
        "preservim/vim-markdown",
        dependencies = { "godlygeek/tabular" },
        config = function()
            -- vim.keymap.set("n", "<leader>o", "<cmd>Toc<CR>", { buffer = true, remap = false })
            vim.keymap.set("n", "<leader>tf", "<cmd>TableFormat<CR>", { buffer = true, remap = false })
        end,
        ft = { "markdown" },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            { "<leader>md", "<cmd>MarkdownPreview<CR>" },
        },
        config = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_theme = "light"
            vim.g.vim_markdown_math = true
        end,
    },
    { "iamcco/mathjax-support-for-mkdp" },
    -- MacOS: brew install glow
    -- https://github.com/charmbracelet/glow
    {
        "ellisonleao/glow.nvim",
        config = function()
            require("glow").setup()
        end,
    },

    { "mmarchini/bpftrace.vim" },

    -- debugger
    -- use("sebdah/vim-delve")
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
    {
        "jbyuki/one-small-step-for-vimkind",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("hb/dap")
        end,
    },

    -- unit test
    -- { "vim-test/vim-test" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            -- "nvim-neotest/neotest-vim-test",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary"),
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                    require("neotest-go"),
                },
                -- TODO:
                -- consumers = {
                --     overseer = require("neotest.consumers.overseer"),
                -- },
            })

            vim.api.nvim_command("command! -nargs=0 NeotestRun :lua require('neotest').run.run()<CR>")
            vim.api.nvim_command("command! -nargs=0 NeotestStop :lua require('neotest').run.stop()<CR>")
            vim.api.nvim_command("command! -nargs=0 NeotestAttach :lua require('neotest').run.attach()<CR>")
            vim.api.nvim_command(
                "command! -nargs=0 NeotestDebugNearest :lua require('neotest').run.run({strategy = 'dap'})<CR>"
            )
            vim.api.nvim_command(
                "command! -nargs=0 NeotestRunFile :lua require('neotest').run.run(vim.fn.expand('%'))<CR>"
            )
            vim.api.nvim_command("command! -nargs=0 NeotestToggleSummary :lua require('neotest').summary.toggle()<CR>")
            vim.api.nvim_command(
                "command! -nargs=0 NeotestJumpPrevFailed :lua require('neotest').jump.prev({ status = 'failed' })<CR>"
            )
            vim.api.nvim_command(
                "command! -nargs=0 NeotestJumpnextFailed :lua require('neotest').jump.next({ status = 'failed' })<CR>"
            )
        end,
    },

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
            })
            vim.keymap.set("n", "<c-q>", '<cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
            vim.keymap.set("i", "<c-q>", '<ESC><cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
            vim.keymap.set("t", "<c-q>", "<c-\\><c-n>:ToggleTerm direction=vertical<CR>")
            vim.keymap.set("n", "<leader>T", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
            vim.keymap.set("t", "<leader>T", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
        end,
    },
    -- tmux
    { "christoomey/vim-tmux-navigator" },
    { "shivamashtikar/tmuxjump.vim" },

    -- free writing
    {
        "folke/zen-mode.nvim",
        opts = {},
    },
}, lazy_options)
