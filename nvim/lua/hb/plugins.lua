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

    -- use("folke/which-key.nvim")
    use("rcarriga/nvim-notify")
    use({ "stevearc/dressing.nvim" })

    -- use("folke/zen-mode.nvim")
    -- use("folke/twilight.nvim")

    use("norcalli/nvim-colorizer.lua")

    -- 中英文排版
    use("hotoo/pangu.vim")

    -- use({ "wfxr/minimap.vim", run = "cargo install --locked code-minimap" })

    use("airblade/vim-rooter")

    use("jamessan/vim-gnupg")

    use("EdenEast/nightfox.nvim")
    -- buffer line at the top of window
    use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })

    -- delete buffer without closing windows
    use("moll/vim-bbye")

    -- Delete all the buffers except the current buffer
    use("schickling/vim-bufonly")

    -- statusline
    use("nvim-lualine/lualine.nvim")

    -- speedup editing friendly
    use("szw/vim-maximizer")
    use({ "mg979/vim-visual-multi", branch = "master" })
    use("rhysd/clever-f.vim")
    use("andymass/vim-matchup")
    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
    })
    -- use('junegunn/vim-slash')
    use("kevinhwang91/nvim-hlslens")
    use("Pocco81/HighStr.nvim")

    -- powered by tpope
    use("tpope/vim-repeat")
    -- use("tpope/vim-surround")
    use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit for the latest features
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
    use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } })

    use("ldelossa/litee.nvim")
    use({
        "ldelossa/litee-calltree.nvim",
        requires = { "ldelossa/litee.nvim" },
    })

    use({
        "pwntester/octo.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "kyazdani42/nvim-web-devicons",
        },
    })
    -- lsp config
    use({ "williamboman/mason.nvim" })
    use("neovim/nvim-lspconfig")
    -- outline powered by lsp
    use("simrat39/symbols-outline.nvim")
    use("j-hui/fidget.nvim")
    -- lsp icons
    use("onsails/lspkind-nvim")
    -- lsp for performance UI.
    -- https://github.com/glepnir/lspsaga.nvim/issues/267
    use("tami5/lspsaga.nvim")

    -- auto completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-nvim-lsp-document-symbol")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use({
        "petertriho/cmp-git",
        requires = "nvim-lua/plenary.nvim",
    })

    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    })

    -- nvim-autopairs can set up <CR>
    use("windwp/nvim-autopairs")

    -- use("hrsh7th/vim-vsnip")
    -- use("hrsh7th/cmp-vsnip")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("rafamadriz/friendly-snippets")

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
    use("kevinhwang91/nvim-bqf")

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
    use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use("nvim-telescope/telescope-dap.nvim")

    -- coding utils
    use("Valloric/ListToggle")
    use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

    use("mbbill/undotree")
    use("AndrewRadev/splitjoin.vim") -- gS gJ
    use("lukas-reineke/indent-blankline.nvim")

    -- langs
    use("rust-lang/rust.vim")
    use("simrat39/rust-tools.nvim")
    use({
        "saecki/crates.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    -- use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
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
    use("rcarriga/nvim-dap-ui")
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
    use("akinsho/toggleterm.nvim")
    -- tmux
    use("christoomey/vim-tmux-navigator")
    use("shivamashtikar/tmuxjump.vim")

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
