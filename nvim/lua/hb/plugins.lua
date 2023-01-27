local INSTALL_PATH = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

---@diagnostic disable-next-line: missing-parameter
if vim.fn.empty(vim.fn.glob(INSTALL_PATH)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", INSTALL_PATH })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init({
    max_jobs = 99,
    --     display = {
    --         open_fn = function()
    --             return require"packer.util".float { border = "rounded" }
    --         end
    --     }
})

-- MacOS: ulimit -S -n 200048
return packer.startup(function(use)
    use("wbthomason/packer.nvim")

    -- use("folke/which-key.nvim")
    use("rcarriga/nvim-notify")

    -- use({
    --     "folke/noice.nvim",
    --     event = "VimEnter",
    --     config = function()
    --         require("noice").setup({
    --             popupmenu = {
    --                 enabled = true,
    --                 backend = "cmp",
    --             },
    --             routes = {
    --                 {
    --                     filter = {
    --                         event = "msg_show",
    --                         kind = "",
    --                         find = "written",
    --                     },
    --                     opts = { skip = true },
    --                 },
    --                 {
    --                     filter = {
    --                         event = "msg_show",
    --                         kind = "search_count",
    --                     },
    --                     opts = { skip = true },
    --                 },
    --             },
    --         })
    --     end,
    --     requires = {
    --         "MunifTanjim/nui.nvim",
    --         "rcarriga/nvim-notify",
    --     },
    -- })
    use({
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({})
        end,
    })

    -- use("folke/zen-mode.nvim")
    -- use("folke/twilight.nvim")

    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    })

    -- 中英文排版
    use("hotoo/pangu.vim")

    -- use({ "wfxr/minimap.vim", run = "cargo install --locked code-minimap" })

    use("airblade/vim-rooter")

    use("jamessan/vim-gnupg")

    use("EdenEast/nightfox.nvim")
    use("ellisonleao/gruvbox.nvim")
    use({ "catppuccin/nvim", as = "catppuccin" })
    use({
        "folke/styler.nvim",
        config = function()
            require("styler").setup({
                themes = {
                    markdown = { colorscheme = "gruvbox" },
                    help = { colorscheme = "catppuccin-mocha", background = "dark" },
                },
            })
        end,
    })

    -- buffer line at the top of window
    use({
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        requires = "kyazdani42/nvim-web-devicons",
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
    })

    -- use({
    --     "nvim-zh/colorful-winsep.nvim",
    --     config = function()
    --         require("colorful-winsep").setup({
    --             highlight = {
    --                 guifg = "#a9a1e1",
    --             },
    --         })
    --     end,
    -- })

    -- delete buffer without closing windows
    use("moll/vim-bbye")

    -- Delete all the buffers except the current buffer
    use("schickling/vim-bufonly")

    -- statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = "SmiteshP/nvim-gps",
        config = [[require("hb/statusline")]],
    })

    -- speedup editing friendly
    use("szw/vim-maximizer")
    use({ "mg979/vim-visual-multi", branch = "master" })
    use("rhysd/clever-f.vim")
    use("andymass/vim-matchup")
    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup({})
        end,
    })
    -- use('junegunn/vim-slash')
    use({
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({ calm_down = true })
            vim.keymap.set(
                "n",
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
            )
            vim.keymap.set(
                "n",
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
            )
            vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]])
            vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]])
            vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]])
            vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]])
            -- vim.keymap.set("n", "<Leader>l", ":noh<CR>")
            vim.cmd([[
                aug VMlens
                    au!
                    au User visual_multi_start lua require("hb/vmlens").start()
                    au User visual_multi_exit lua require("hb/vmlens").exit()
                aug END
            ]])
        end,
    })
    use({
        "Pocco81/HighStr.nvim",
        config = function()
            vim.keymap.set("v", "<F6>", ":<c-u>HSHighlight 1<CR>")
            vim.keymap.set("v", "<F7>", ":<c-u>HSRmHighlight<CR>")
        end,
    })

    -- powered by tpope
    use("tpope/vim-repeat")
    -- use("tpope/vim-surround")
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit for the latest features
        config = function()
            require("nvim-surround").setup({})
        end,
    })
    use("tpope/vim-speeddating")
    use("tpope/vim-unimpaired")
    use("tpope/vim-commentary")

    -- git
    use("tpope/vim-fugitive")
    use("junegunn/gv.vim")
    use("sindrets/diffview.nvim")
    use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use({ "ruifm/gitlinker.nvim", requires = "nvim-lua/plenary.nvim" })

    -- powered by svermeulen
    use("svermeulen/vim-subversive")
    use("svermeulen/vim-yoink")

    -- nvim-tree
    use({
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = [[require("hb/nvim-tree")]],
    })

    use({
        "ldelossa/litee.nvim",
        config = function()
            require("litee.lib").setup({
                on_open = "popout",
                panel = {
                    orientation = "right",
                    panel_size = 30,
                },
                tree = { icon_set = "codicons" },
            })
        end,
    })
    use({
        "ldelossa/litee-calltree.nvim",
        requires = { "ldelossa/litee.nvim" },
        config = function()
            require("litee.calltree").setup({})
        end,
    })

    use({
        "pwntester/octo.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("octo").setup({})
        end,
    })
    -- lsp config
    use({
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
    })
    use("neovim/nvim-lspconfig")
    -- outline powered by lsp
    use({
        "simrat39/symbols-outline.nvim",
        config = function()
            require("symbols-outline").setup({
                relative_width = true,
                auto_preview = false,
                position = "right",
            })
        end,
        setup = function()
            vim.keymap.set("n", "<leader>v", "<cmd>SymbolsOutline<CR>")
        end,
    })
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    })
    -- lsp for performance UI.
    -- https://github.com/glepnir/lspsaga.nvim/issues/267
    use("tami5/lspsaga.nvim")

    -- snippets
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")

    -- auto completion
    -- use("hrsh7th/cmp-emoji")
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
            { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
            {
                "petertriho/cmp-git",
                requires = "nvim-lua/plenary.nvim",
                config = function()
                    require("cmp_git").setup({})
                end,
                after = "nvim-cmp",
            },
        },
        config = [[require("hb/compe")]],
        event = "InsertEnter",
        wants = "LuaSnip",
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        setup = function()
            -- trouble.nvim mappings
            vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
            vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
            vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
            vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
            vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
            vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>")
            -- Disable vim-dispatch mappings
            vim.g.dispatch_no_maps = 1
        end,
        config = function()
            require("trouble").setup({})
        end,
    })

    -- nvim-autopairs can set up <CR>
    use("windwp/nvim-autopairs")

    -- tree sitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("nvim-treesitter/nvim-treesitter-refactor")
    use("romgrk/nvim-treesitter-context")
    use("RRethy/nvim-treesitter-endwise")
    use("JoosepAlviste/nvim-ts-context-commentstring")
    -- use({ "stsewd/sphinx.nvim", run = ":UpdateRemotePlugins" })
    use("theprimeagen/jvim.nvim") -- for json
    use({
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
    })

    -- better quickfix window
    use({
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
    })

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
    use("kshenoy/vim-signature")

    -- registers
    use("tversteeg/registers.nvim")

    -- fzf
    use({ "junegunn/fzf", dir = "~/.fzf", run = "./install --all" })
    use("junegunn/fzf.vim")

    -- telescope
    use({
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = [[require("hb/telescope")]],
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("nvim-telescope/telescope-dap.nvim")

    -- coding utils
    use("Valloric/ListToggle")
    use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

    use("mbbill/undotree")
    use("AndrewRadev/splitjoin.vim") -- gS gJ
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                show_current_context_start = true,
            })
        end,
    })

    -- langs
    use("rust-lang/rust.vim")
    use("simrat39/rust-tools.nvim")
    use({
        "saecki/crates.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    })

    use({ "ray-x/go.nvim", requires = { "ray-x/guihua.lua" } })

    -- for lua develop
    use({
        "folke/neodev.nvim",
        config = function()
            library = { plugins = { "nvim-dap-ui" }, types = true }
        end,
    })

    use("mfussenegger/nvim-jdtls")
    use("mmarchini/bpftrace.vim")

    -- markdown
    use("mzlogin/vim-markdown-toc")
    use({ "preservim/vim-markdown", requires = { "godlygeek/tabular" } })
    use({ -- https://github.com/iamcco/markdown-preview.nvim/issues/354
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_theme = "light"
        end,
        ft = { "markdown" },
        cmd = "MarkdownPreview",
    })
    use("iamcco/mathjax-support-for-mkdp")
    -- MacOS: brew install glow
    -- https://github.com/charmbracelet/glow
    use("npxbr/glow.nvim")

    -- debugger
    -- use("sebdah/vim-delve")
    use("mfussenegger/nvim-dap")
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    use("theHamsta/nvim-dap-virtual-text")
    use("mfussenegger/nvim-dap-python")
    use("leoluz/nvim-dap-go")
    use("jbyuki/one-small-step-for-vimkind")

    -- unit test
    use("vim-test/vim-test")
    use({
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-vim-test",
        },
    })

    -- Terminal
    use({
        "akinsho/toggleterm.nvim",
        setup = function()
            vim.keymap.set("n", "<c-q>", '<cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
            vim.keymap.set("i", "<c-q>", '<ESC><cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
            vim.keymap.set("t", "<c-q>", "<c-\\><c-n>:ToggleTerm direction=vertical<CR>")
            vim.keymap.set("n", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
            vim.keymap.set("t", "<leader>th", '<cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>')
        end,
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
        end,
    })
    -- tmux
    use("christoomey/vim-tmux-navigator")
    use("shivamashtikar/tmuxjump.vim")

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
