call plug#begin('~/.config/nvim/plugged')

Plug 'rcarriga/nvim-notify'

Plug 'folke/zen-mode.nvim'
Plug 'folke/twilight.nvim'

Plug 'norcalli/nvim-colorizer.lua'

" 中英文排版
Plug 'hotoo/pangu.vim'

Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

Plug 'airblade/vim-rooter'

" gnupg
Plug 'jamessan/vim-gnupg'

" theme
Plug 'EdenEast/nightfox.nvim'

" buffer line at the top of window
Plug 'akinsho/nvim-bufferline.lua'
" delete buffer without closing windows
Plug 'moll/vim-bbye'
" Delete all the buffers except the current buffer.
Plug 'schickling/vim-bufonly'
" statusline
" Plug 'datwaft/bubbly.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'arkav/lualine-lsp-progress'

" speedup editing friendly
" Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'rhysd/clever-f.vim'
" Plug 'easymotion/vim-easymotion'
Plug 'karb94/neoscroll.nvim'
Plug 'andymass/vim-matchup'

" powered by tpope
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
" Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-commentary'


" git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'sindrets/diffview.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ruifm/gitlinker.nvim'

" powered by svermeulen
Plug 'svermeulen/vim-subversive'
" Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'

" nvim-tree
Plug 'kyazdani42/nvim-tree.lua'

" lsp config
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
" outline powered by lsp
Plug 'simrat39/symbols-outline.nvim'
" lsp status
Plug 'nvim-lua/lsp-status.nvim'
" lsp icons
Plug 'onsails/lspkind-nvim'

" auto completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
" Plug 'kdheepak/cmp-latex-symbols'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'lukas-reineke/cmp-rg'

" nvim-autopairs can set up <CR>
Plug 'windwp/nvim-autopairs'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'
"
Plug 'rafamadriz/friendly-snippets'

" lsp for performance UI.
" https://github.com/glepnir/lspsaga.nvim/issues/267
Plug 'tami5/lspsaga.nvim'

" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'stsewd/sphinx.nvim', { 'do': ':UpdateRemotePlugins' }

" sign marks
Plug 'kshenoy/vim-signature'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" better quickfix window
Plug 'kevinhwang91/nvim-bqf'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'


" coding utils
" Plug 'editorconfig/editorconfig-vim'
Plug 'dense-analysis/ale'
" Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'AndrewRadev/splitjoin.vim' "gS gJ
" Plug 'ludovicchabant/vim-gutentags'
Plug 'lukas-reineke/indent-blankline.nvim'

" langs
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" for lua develop
Plug 'folke/lua-dev.nvim'

Plug 'mfussenegger/nvim-jdtls'

Plug 'mmarchini/bpftrace.vim'

" markdown
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'iamcco/mathjax-support-for-mkdp'
" MacOS: brew install glow
" https://github.com/charmbracelet/glow
Plug 'npxbr/glow.nvim', {'do': ':GlowInstall'}

" debugger
" Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'sebdah/vim-delve'

Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'mfussenegger/nvim-dap-python'
Plug 'leoluz/nvim-dap-go'
Plug 'jbyuki/one-small-step-for-vimkind'

" unit test
Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }

" Terminal
Plug 'kassio/neoterm'
" tmux
Plug 'christoomey/vim-tmux-navigator'

Plug 'antoinemadec/FixCursorHold.nvim'
call plug#end()

noremap <Leader>pi :<c-u>PlugInstall<CR>
noremap <Leader>pu :<c-u>PlugUpdate<CR>
noremap <Leader>pc :<c-u>PlugClean<CR>

" colorscheme gruvbox8_hard
colorscheme nightfox

" vim-test
function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction

nnoremap <silent> td :call DebugNearest()<CR>
nnoremap <silent> tt :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
nnoremap <silent> t_ :TestLast<CR>

let test#strategy = "neovim"
let test#neovim#term_position = "rightbelow"
" vim-test end

" clever-f
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
" clever-fend

" vim-bbye
noremap <leader><BS> :Bdelete<cr>
" vim-bbye end

if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

" vim-visual-multi
let g:VM_leader = '\\'
" vim-visual-multi end

" markdown
let g:vim_markdown_math = 1
nmap <leader>md :MarkdownPreview<CR>
" markdown end

" vim-go
" 使用vim-go功能
" 1. fmt autosave
" 2. 重新启动 vim-go gopls，vim-go 维护 tags 跳转更实用
let g:go_gopls_enabled = 1
let g:go_def_mapping_enabled = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_diagnostics_enabled = 0
let g:go_auto_type_info = 0
let g:go_code_completion_enabled = 0
let g:go_doc_keywordprg_enabled = 0 "disabled, using K lsp hover()
let g:go_doc_popup_window = 0
let g:go_mod_fmt_autosave = 0
let g:go_textobj_enabled = 0
let g:go_metalinter_autosave_enabled = []
let g:go_metalinter_enabled = []
let g:go_addtags_transform = 'camelcase'
let g:go_list_type = "quickfix"
let g:go_echo_go_info = 0
" vim-go end

" ale
let g:ale_completion_enabled = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_lint_on_enter = 0
let g:ale_linters_explicit = 1
let g:ale_linters = {
\ 'python': ['pylint', 'pyright'],
\ 'sh': ['shellcheck'],
\ 'markdown':['remark-lint'],
\ 'go': ['gofmt', 'golint', 'go vet', 'staticcheck'],
\ }
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'python': ['yapf', 'autoimport'],
\ 'go': ['goimports'],
\ 'markdown':['remark-lint'],
\ 'sh':['shfmt'],
\ 'vue': ['prettier'],
\ }
let g:ale_fix_on_save = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
nmap <silent> ]s <Plug>(ale_next_wrap)
nmap <silent> [s <Plug>(ale_previous_wrap)
"ale end

" vim-subversive
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" <leader>s<motion1><motion2>
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)
" vim-subversive end

" vim-yoink
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
" vim-yoink end

" neoterm
let g:neoterm_default_mod = 'vertical'
let g:neoterm_size = 60
let g:neoterm_autoinsert = 1
nnoremap <c-q> <cmd>Ttoggle<CR>
inoremap <c-q> <ESC>:Ttoggle<CR>
tnoremap <c-q> <c-\><c-n>:Ttoggle<CR>
let g:neoterm_term_per_tab = 1

"neoterm end

" fzf
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_action = {
  \ 'ctrl-x': 'split',
  \ 'ctrl-]': 'vsplit' }

inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
      \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
      \ fzf#wrap({'dir': expand('%:p:h')}))

if has('nvim')
  au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au! FileType fzf tunmap <buffer> <Esc>
endif
" fzf end
"

" symbols-outline
nnoremap <silent> <leader>v :SymbolsOutline<CR>
" symbols-outline end

" vim-vsnip
let g:vsnip_snippet_dir = '~/.config/nvim/vsnip'
" vim-vsnip end

" indent-blankline
let g:indent_blankline_filetype = ['vim', 'lua', 'python']
" indent-blankline end

" vim-matchup
let g:matchup_surround_enabled = 1
let g:matchup_transmute_enabled = 1
" vim-matchup end

" minimap.vim
let g:minimap_width = 10
let g:minimap_auto_start = 0
let g:minimap_auto_start_win_enter = 0
" minimap.vim end

" vim-rooter
let g:rooter_patterns = [
\ '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json',
\ 'tox.ini'
\]
" vim-rooter end

" nvim-jdtls
augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require'hb/lsp/jdtls'.setup()
augroup end
" nvim-jdtls end

" FixCursorHold.nvim
let g:cursorhold_updatetime = 100
" FixCursorHold.nvim end
