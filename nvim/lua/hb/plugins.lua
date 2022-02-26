local INSTALL_PATH = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

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

-- packer.init {
--     display = {
--         open_fn = function()
--             return require"packer.util".float { border = "rounded" }
--         end
--     }
-- }

-- MacOS: ulimit -S -n 200048
return packer.startup(function(use)
    use("wbthomason/packer.nvim")

    use("rcarriga/nvim-notify")

    use({
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({})
        end,
    })
    use("folke/twilight.nvim")

    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    })

    -- 中英文排版
    use("hotoo/pangu.vim")

    use({ "wfxr/minimap.vim", run = "cargo install --locked code-minimap" })

    use("airblade/vim-rooter")

    use("jamessan/vim-gnupg")

    use("EdenEast/nightfox.nvim")

    -- buffer line at the top of window
    use("akinsho/nvim-bufferline.lua")

    -- delete buffer without closing windows
    use("moll/vim-bbye")

    -- Delete all the buffers except the current buffer
    use("schickling/vim-bufonly")

    -- statusline
    use("nvim-lualine/lualine.nvim")

    -- speedup editing friendly
    use({ "mg979/vim-visual-multi", branch = "master" })
    use("rhysd/clever-f.vim")
    use({
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({})
        end,
    })
    use("andymass/vim-matchup")
    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup({})
        end,
    })

    -- powered by tpope
    use("tpope/vim-repeat")
    use("tpope/vim-surround")
    use("tpope/vim-speeddating")
    use("tpope/vim-unimpaired")
    use("tpope/vim-rhubarb")
    use("tpope/vim-dispatch")
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
    -- use 'svermeulen/vim-cutlass'

    -- nvim-tree
    use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } })

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

    -- lsp config
    use("neovim/nvim-lspconfig")
    use("ray-x/lsp_signature.nvim")
    -- outline powered by lsp
    use("simrat39/symbols-outline.nvim")
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    })
    -- lsp icons
    use("onsails/lspkind-nvim")

    -- auto completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-nvim-lsp-document-symbol")
    use("quangnguyen30192/cmp-nvim-tags")
    -- use("lukas-reineke/cmp-rg")
    use({
        "petertriho/cmp-git",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("cmp_git").setup({})
        end,
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({})
        end,
    })

    -- nvim-autopairs can set up <CR>
    use("windwp/nvim-autopairs")

    use("hrsh7th/vim-vsnip")
    use("hrsh7th/cmp-vsnip")
    use("rafamadriz/friendly-snippets")
    -- lsp for performance UI.
    -- https://github.com/glepnir/lspsaga.nvim/issues/267
    use("tami5/lspsaga.nvim")

    -- tree sitter
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("nvim-treesitter/nvim-treesitter-refactor")
    use("romgrk/nvim-treesitter-context")
    use("RRethy/nvim-treesitter-endwise")
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use({ "stsewd/sphinx.nvim", run = ":UpdateRemotePlugins" })
    use("theprimeagen/jvim.nvim")

    -- sign marks
    use("kshenoy/vim-signature")
    -- registers
    use("tversteeg/registers.nvim")

    -- fzf
    use({ "junegunn/fzf", dir = "~/.fzf", run = "./install --all" })
    use("junegunn/fzf.vim")

    -- better quickfix window
    use("kevinhwang91/nvim-bqf")

    -- telescope
    use("nvim-lua/popup.nvim")
    use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
    -- use 'nvim-telescope/telescope-ui-select.nvim'
    use("nvim-telescope/telescope-fzf-writer.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("nvim-telescope/telescope-symbols.nvim")
    use("nvim-telescope/telescope-dap.nvim")

    -- coding utils
    use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

    use("mbbill/undotree")
    use("AndrewRadev/splitjoin.vim") -- gS gJ
    use("lukas-reineke/indent-blankline.nvim")

    -- langs
    use("rust-lang/rust.vim")
    use("simrat39/rust-tools.nvim")
    use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
    -- for lua develop
    use("folke/lua-dev.nvim")
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
        end,
        ft = { "markdown" },
        cmd = "MarkdownPreview",
    })
    use("iamcco/mathjax-support-for-mkdp")
    -- MacOS: brew install glow
    -- https://github.com/charmbracelet/glow
    use("npxbr/glow.nvim")

    -- debugger
    use("szw/vim-maximizer")
    use("sebdah/vim-delve")
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    use("mfussenegger/nvim-dap-python")
    use("leoluz/nvim-dap-go")
    use("jbyuki/one-small-step-for-vimkind")

    -- unit test
    use("vim-test/vim-test")
    use({ "rcarriga/vim-ultest", run = ":UpdateRemotePlugins" })

    -- Terminal
    use("akinsho/toggleterm.nvim")

    -- tmux
    use("christoomey/vim-tmux-navigator")

    use("antoinemadec/FixCursorHold.nvim")

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
