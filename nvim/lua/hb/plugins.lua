local INSTALL_PATH = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(INSTALL_PATH)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", INSTALL_PATH }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require"packer.util".float { border = "rounded" }
        end
    }
}

-- MacOS: ulimit -S -n 200048
return packer.startup(function(use)
    -- My plugins here
    use 'wbthomason/packer.nvim' -- Have packer manage itself

    use 'rcarriga/nvim-notify'

    use 'folke/zen-mode.nvim'
    use 'folke/twilight.nvim'

    use 'norcalli/nvim-colorizer.lua'

    -- 中英文排版
    use 'hotoo/pangu.vim'

    use { 'wfxr/minimap.vim', run = 'cargo install --locked code-minimap' }

    use 'airblade/vim-rooter'

    use 'jamessan/vim-gnupg'

    use 'EdenEast/nightfox.nvim'

    -- buffer line at the top of window
    use 'akinsho/nvim-bufferline.lua'

    -- delete buffer without closing windows
    use 'moll/vim-bbye'

    -- Delete all the buffers except the current buffer
    use 'schickling/vim-bufonly'

    -- statusline
    use 'nvim-lualine/lualine.nvim'

    use 'arkav/lualine-lsp-progress'

    -- speedup editing friendly
    use { 'mg979/vim-visual-multi', branch = 'master' }
    use 'rhysd/clever-f.vim'
    use 'karb94/neoscroll.nvim'
    use 'andymass/vim-matchup'

    -- powered by tpope
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-speeddating'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-rhubarb'
    use 'tpope/vim-dispatch'
    use 'tpope/vim-commentary'

    -- git
    use 'tpope/vim-fugitive'
    use 'junegunn/gv.vim'
    use 'sindrets/diffview.nvim'
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end
    }
    use { 'ruifm/gitlinker.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- powered by svermeulen
    use 'svermeulen/vim-subversive'
    use 'svermeulen/vim-yoink'
    -- use 'svermeulen/vim-cutlass'

    -- nvim-tree
    use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }

    use 'ldelossa/litee.nvim'
    use 'ldelossa/litee-calltree.nvim'

    -- lsp config
    use 'neovim/nvim-lspconfig'
    use 'ray-x/lsp_signature.nvim'
    -- outline powered by lsp
    use 'simrat39/symbols-outline.nvim'
    -- lsp status
    use 'nvim-lua/lsp-status.nvim'
    -- lsp icons
    use 'onsails/lspkind-nvim'

    -- auto completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-emoji'
    use 'hrsh7th/cmp-nvim-lsp-document-symbol'
    use 'quangnguyen30192/cmp-nvim-tags'
    use 'lukas-reineke/cmp-rg'

    -- nvim-autopairs can set up <CR>
    use 'windwp/nvim-autopairs'

    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-vsnip'
    use 'rafamadriz/friendly-snippets'
    -- lsp for performance UI.
    -- https://github.com/glepnir/lspsaga.nvim/issues/267
    use 'tami5/lspsaga.nvim'

    -- tree sitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use { 'stsewd/sphinx.nvim', run = ':UpdateRemotePlugins' }

    -- sign marks
    use 'kshenoy/vim-signature'

    -- fzf
    use { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
    use 'junegunn/fzf.vim'

    -- better quickfix window
    use 'kevinhwang91/nvim-bqf'

    -- telescope
    use 'nvim-lua/popup.nvim'
    use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
    -- use 'nvim-telescope/telescope-ui-select.nvim'
    use 'nvim-telescope/telescope-fzf-writer.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'nvim-telescope/telescope-symbols.nvim'
    use 'nvim-telescope/telescope-dap.nvim'

    -- coding utils
    use 'dense-analysis/ale'
    use 'mbbill/undotree'
    use 'AndrewRadev/splitjoin.vim' -- gS gJ
    use 'lukas-reineke/indent-blankline.nvim'

    -- langs
    use 'rust-lang/rust.vim'
    use 'simrat39/rust-tools.nvim'
    use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
    -- for lua develop
    use 'folke/lua-dev.nvim'
    use 'mfussenegger/nvim-jdtls'
    use 'mmarchini/bpftrace.vim'

    -- markdown
    use 'mzlogin/vim-markdown-toc'
    use { 'iamcco/markdown-preview.nvim', run = 'cd app & yarn install' }
    use 'iamcco/mathjax-support-for-mkdp'
    -- MacOS: brew install glow
    -- https://github.com/charmbracelet/glow
    use 'npxbr/glow.nvim'

    -- debugger
    use 'szw/vim-maximizer'
    use 'sebdah/vim-delve'
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'mfussenegger/nvim-dap-python'
    use 'leoluz/nvim-dap-go'
    use 'jbyuki/one-small-step-for-vimkind'

    -- unit test
    use 'vim-test/vim-test'
    use { 'rcarriga/vim-ultest', run = ':UpdateRemotePlugins' }

    -- Terminal
    use 'kassio/neoterm'
    -- tmux
    use 'christoomey/vim-tmux-navigator'

    use 'antoinemadec/FixCursorHold.nvim'

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end

end)
