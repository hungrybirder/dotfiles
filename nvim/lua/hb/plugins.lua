local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local lazy_options = {
    ui = {
        size = { width = 1.0, height = 1.0 },
    },
    diff = {
        cmd = "diffview.nvim",
    },
}

vim.keymap.set("n", "<leader>pu", "<cmd>Lazy sync<CR>")

require("lazy").setup({

    {
        "rcarriga/nvim-notify",
        config = function()
            notify = require("notify")
            notify.setup({})
            vim.notify = notify
        end,
    },
    { "hotoo/pangu.vim" },
    { "airblade/vim-rooter" },
    { "jamessan/vim-gnupg" },
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
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
                        { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left" },
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
    { "andymass/vim-matchup" },
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
    { "tpope/vim-commentary" },

    -- git
    { "tpope/vim-fugitive" },
    { "junegunn/gv.vim" },
    -- save my last cursor position
    {
        "ethanholz/nvim-lastplace",
        config = function()
            require("nvim-lastplace").setup({
                lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
                lastplace_open_folds = true,
            })
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
    { "catppuccin/nvim", name = "catppuccin" },
    {
        "folke/styler.nvim",
        config = function()
            require("styler").setup({
                themes = {
                    markdown = { colorscheme = "gruvbox" },
                    help = { colorscheme = "catppuccin-mocha", background = "dark" },
                },
            })
        end,
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
    { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "ruifm/gitlinker.nvim", dependencies = "nvim-lua/plenary.nvim" },

    -- powered by svermeulen
    { "svermeulen/vim-subversive" },
    { "svermeulen/vim-yoink" },

    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("hb/nvim-tree")
        end,
    },

    {
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("octo").setup({})
        end,
    },
    -- lsp config
    {
        "williamboman/mason.nvim",
        -- MasonInstall ansible-language-server awk-language-server bash-language-server clangd cmake-language-server codelldb debugpy dockerfile-language-server go-debug-adapter gopls html-lsp json-lsp kotlin-language-server lua-language-server prettier pyright rust-analyzer shellcheck shfmt solargraph sql-formatter sqlls stylua texlab typescript-language-server vim-language-server vls yaml-language-server
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    { "neovim/nvim-lspconfig" },
    -- outline powered by lsp
    {
        "simrat39/symbols-outline.nvim",
        config = function()
            require("symbols-outline").setup({
                relative_width = true,
                auto_preview = false,
                position = "right",
            })
            vim.keymap.set("n", "<leader>v", "<cmd>SymbolsOutline<CR>")
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    },
    -- lsp for performance UI.
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({
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
                        edit = "e",
                        vsplit = "v",
                        split = "s",
                        tabe = "t",
                        jump = "o",
                        quit = "q",
                        expand_collapse = "u",
                    },
                },
                beacon = {
                    enable = true,
                    frequency = 7,
                },
                finder = {
                    max_height = 0.5,
                    min_width = 30,
                    force_max_height = false,
                    keys = {
                        jump_to = "p",
                        expand_or_jump = "o",
                        vsplit = "s",
                        split = "i",
                        tabe = "t",
                        tabnew = "r",
                        quit = { "q", "<ESC>" },
                        close_in_preview = "<ESC>",
                    },
                },
            })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" },
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
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol" },
            {
                "petertriho/cmp-git",
                dependencies = "nvim-lua/plenary.nvim",
                config = function()
                    require("cmp_git").setup({})
                end,
            },
            { "L3MON4D3/LuaSnip" },
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
            require("trouble").setup({})
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

    -- nvim-autopairs can set up <CR>
    { "windwp/nvim-autopairs" },

    -- tree sitter
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "nvim-treesitter/playground" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "nvim-treesitter/nvim-treesitter-refactor" },
    { "romgrk/nvim-treesitter-context" },
    { "RRethy/nvim-treesitter-endwise" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "theprimeagen/jvim.nvim" }, -- for json
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
    },

    -- better quickfix window
    {
        "kevinhwang91/nvim-bqf",
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

    -- sign marks
    -- mx           Toggle mark 'x' and display it in the leftmost column
    -- dmx          Remove mark 'x' where x is a-zA-Z
    -- m,           Place the next available mark
    -- m.           If no mark on line, place the next available mark. Otherwise, remove (first) existing mark.
    -- m-           Delete all marks from the current line
    -- m<Space>     Delete all marks from the current buffer
    -- ]`           Jump to next mark
    -- [`           Jump to prev mark
    -- ]'           Jump to start of next line containing a mark
    -- ['           Jump to start of prev line containing a mark
    -- `]           Jump by alphabetical order to next mark
    -- `[           Jump by alphabetical order to prev mark
    -- ']           Jump by alphabetical order to start of next line having a mark
    -- '[           Jump by alphabetical order to start of prev line having a mark
    -- m/           Open location list and display marks from current buffer
    -- m[0-9]       Toggle the corresponding marker !@#$%^&*()
    -- m<S-[0-9]>   Remove all markers of the same type
    -- ]-           Jump to next line having a marker of the same type
    -- [-           Jump to prev line having a marker of the same type
    -- ]=           Jump to next line having a marker of any type
    -- [=           Jump to prev line having a marker of any type
    -- m?           Open location list and display markers from current buffer
    -- m<BS>        Remove all markers
    { "kshenoy/vim-signature" },

    -- registers
    { "tversteeg/registers.nvim" },

    -- fzf
    { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
    { "junegunn/fzf.vim" },

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
    { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters

    { "mbbill/undotree" },
    { "AndrewRadev/splitjoin.vim" },
    -- {
    --     "bennypowers/splitjoin.nvim",
    --     keys = {
    --         {
    --             "gJ",
    --             function()
    --                 require("splitjoin").join()
    --             end,
    --             desc = "Join the object under cursor",
    --         },
    --         {
    --             "gS",
    --             function()
    --                 require("splitjoin").split()
    --             end,
    --             desc = "Split the object under cursor",
    --         },
    --     },
    -- },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                show_current_context_start = true,
            })
        end,
    },

    -- dev languages
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
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },

    -- for lua develop
    {
        "folke/neodev.nvim",
        config = function()
            library = { plugins = { "nvim-dap-ui" }, types = true }
        end,
    },

    { "mfussenegger/nvim-jdtls" },
    { "mmarchini/bpftrace.vim" },

    -- markdown
    { "mzlogin/vim-markdown-toc" },
    { "preservim/vim-markdown", dependencies = { "godlygeek/tabular" } },
    {
        -- https://github.com/iamcco/markdown-preview.nvim/issues/354
        "iamcco/markdown-preview.nvim",
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
        ft = { "markdown" },
        cmd = "MarkdownPreview",
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

    -- debugger
    -- use("sebdah/vim-delve")
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
    { "theHamsta/nvim-dap-virtual-text" },
    { "mfussenegger/nvim-dap-python" },
    { "leoluz/nvim-dap-go" },
    { "jbyuki/one-small-step-for-vimkind" },

    -- unit test
    { "vim-test/vim-test" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-vim-test",
        },
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
            vim.keymap.set("n", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
            vim.keymap.set("t", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
        end,
    },
    -- tmux
    { "christoomey/vim-tmux-navigator" },
    { "shivamashtikar/tmuxjump.vim" },
}, lazy_options)
