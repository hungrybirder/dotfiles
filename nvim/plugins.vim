call plug#begin('~/.config/nvim/plugged')

Plug 'folke/zen-mode.nvim'

" 中英文排版
Plug 'hotoo/pangu.vim'

Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

Plug 'tpope/vim-dispatch'

Plug 'airblade/vim-rooter'
Plug 'tweekmonster/startuptime.vim'
" Plug 'dstein64/vim-startuptime'

" gnupg
Plug 'jamessan/vim-gnupg'

" theme
Plug 'lifepillar/vim-gruvbox8'
Plug 'EdenEast/nightfox.nvim'

Plug 'akinsho/nvim-bufferline.lua'

" statusline
Plug 'datwaft/bubbly.nvim'

" delete buffer without closing windows
Plug 'moll/vim-bbye'
" Delete all the buffers except the current buffer.
Plug 'schickling/vim-bufonly'

" speedup editing friendly
" Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'rhysd/clever-f.vim'
Plug 'easymotion/vim-easymotion'
Plug 'karb94/neoscroll.nvim'
Plug 'andymass/vim-matchup'

" powered by tpope
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rhubarb'

" git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'junegunn/gv.vim'
Plug 'sindrets/diffview.nvim'

" powered by svermeulen
Plug 'svermeulen/vim-subversive'
" Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'

" tagbar
" Plug 'preservim/tagbar'
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
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
" Plug 'kdheepak/cmp-latex-symbols'
Plug 'quangnguyen30192/cmp-nvim-tags'

" nvim-autopairs can set up <CR>
Plug 'windwp/nvim-autopairs'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'
"
Plug 'rafamadriz/friendly-snippets'

" lsp for performance UI.
" Plug 'glepnir/lspsaga.nvim'
" Plug 'https://github.com/rinx/lspsaga.nvim'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'

" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/completion-treesitter'
Plug 'nvim-treesitter/playground'
" Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" sign marks
Plug 'kshenoy/vim-signature'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
" better quickfix window
Plug 'kevinhwang91/nvim-bqf'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'nvim-telescope/telescope-vimspector.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'


" coding utils
" Plug 'editorconfig/editorconfig-vim'
Plug 'dense-analysis/ale'
Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'AndrewRadev/splitjoin.vim' "gS gJ
" Plug 'ludovicchabant/vim-gutentags'
Plug 'lukas-reineke/indent-blankline.nvim'

" langs
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/jsonc.vim'

Plug 'mmarchini/bpftrace.vim'

" markdown
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'iamcco/mathjax-support-for-mkdp'
" MacOS: brew install glow
" https://github.com/charmbracelet/glow
Plug 'npxbr/glow.nvim', {'do': ':GlowInstall'}

" debugger
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'sebdah/vim-delve'

Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'theHamsta/nvim-dap-virtual-text'

" unit test
Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }

" Terminal
Plug 'kassio/neoterm'
" tmux
Plug 'christoomey/vim-tmux-navigator'

Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

noremap <Leader>pi :<c-u>PlugInstall<CR>
noremap <Leader>pu :<c-u>PlugUpdate<CR>
noremap <Leader>pc :<c-u>PlugClean<CR>

" colorscheme gruvbox8_hard
colorscheme nightfox

fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun

func! AddToWatch()
  let word = expand("<cexpr>")
  call vimspector#AddWatch(word)
endfun

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         12,
  \    'vimspectorBPCond':     11,
  \    'vimspectorBPDisabled': 10,
  \    'vimspectorPC':         999,
  \ }
let g:vimspector_base_dir = expand('$HOME/.config/vimspector-config')
nnoremap <leader>M :MaximizerToggle!<CR>
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>d? :call AddToWatch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>
nnoremap <leader>dX :call vimspector#ClearBreakpoints()<CR>
" nnoremap <S-k> :call vimspector#StepOut()<CR>
" nnoremap <S-l> :call vimspector#StepInto()<CR>
" nnoremap <S-j> :call vimspector#StepOver()<CR>
nnoremap <leader>d_ :call vimspector#Restart()<CR>
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc :call vimspector#RunToCursor()<CR>
nnoremap <leader>dh :call vimspector#ToggleBreakpoint()<CR>

" function! JestStrategy(cmd)
"   let testName = matchlist(a:cmd, '\v -t ''(.*)''')[1]
"   call vimspector#LaunchWithSettings( #{ configuration: 'jest', TestName: testName } )
" endfunction
" let g:test#custom_strategies = {'jest': function('JestStrategy')}

nnoremap <leader>dd :TestNearest -strategy=jest<CR>

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


" powered by ThePrimeagen
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })<CR>
nnoremap <leader>pw <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>
" nnoremap <silent> <Leader>pf :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 10 }))<cr>
nnoremap <silent> <Leader>pf :Telescope find_files<cr>
nnoremap <silent> <leader>pb <cmd>Telescope current_buffer_fuzzy_find<CR>

nnoremap <silent> <c-p> <cmd>Telescope git_files<CR>

nnoremap <silent> <leader>m  <cmd>Telescope oldfiles<CR>
nnoremap <silent> <leader>o  <cmd>Telescope treesitter<CR>
nnoremap <silent> <leader>b  <cmd>Telescope buffers<CR>
nnoremap <silent> <leader>a  <cmd>Telescope live_grep<CR>
nnoremap <silent> <leader>r  <cmd>Telescope lsp_references<CR>
nnoremap <silent> <leader>cs <cmd>Telescope lsp_document_symbols<CR>
nnoremap <silent> <leader>ws <cmd>lua require('telescope.builtin').lsp_workspace_symbols{query="*"}<CR>
nnoremap <silent> <leader>ts  <cmd>Telescope tagstack<CR>

" clever-f
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
" clever-fend

" easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0
nmap <leader>w <Plug>(easymotion-bd-w)
" easymotion end

" auto-pairs
" macos iTerm2 设置Meta key方法 Preferences=>Profiles=>Keys Left Option Key: Esc+
"
" toggle  <M-p>
" fast wrap word <M-e>
" --- How to insert parens purely? ---
" There are 3 ways:
"     1. Use Ctrl-V ) to insert paren without trigger the plugin.
"     2. Use Alt-P to turn off the plugin.
"     3. Use DEL or <C-O>x to delete the character insert by plugin.
" let g:AutoPairsFlyMode = 1
" let g:AutoPairsMapSpace = 0 " 禁止MapSpace
" auto-pairs end

" vim-bbye
noremap <leader><BS> :Bdelete<cr>
" vim-bbye end

if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

" tagbar
" nnoremap <silent> <leader>2 :TagbarToggle<CR>
" let tags = "./tags"
" let g:tagbar_autofocus = 0
" let g:tagbar_sort = 0
"tagbar end

" vim-visual-multi
let g:VM_leader = '\\'
" vim-visual-multi end

" snip
" let g:UltiSnipsExpandTrigger="<c-l>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" snip end

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
" fugitive
nnoremap <leader>gh :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gs :G<CR>
nnoremap <silent> <leader>gc :GBranches<CR>
nnoremap <leader>ga :Git fetch --all<CR>

let g:fzf_branch_actions = {
\ 'checkout': {
\   'prompt': 'Checkout> ',
\   'execute': 'echo system("{git} checkout {branch}")',
\   'multiple': v:false,
\   'keymap': 'enter',
\   'required': ['branch'],
\   'confirm': v:false,
\ },
\ 'track': {
\   'prompt': 'Track> ',
\   'execute': 'echo system("{git} checkout --track {branch}")',
\   'multiple': v:false,
\   'keymap': 'ctrl-t',
\   'required': ['branch'],
\   'confirm': v:false,
\ },
\ 'create': {
\   'prompt': 'Create> ',
\   'execute': 'echo system("{git} checkout -b {input}")',
\   'multiple': v:false,
\   'keymap': 'ctrl-n',
\   'required': ['input'],
\   'confirm': v:false,
\ },
\ 'delete': {
\   'prompt': 'Delete> ',
\   'execute': 'echo system("{git} branch -D {branch}")',
\   'multiple': v:true,
\   'keymap': 'ctrl-d',
\   'required': ['branch'],
\   'confirm': v:true,
\ },
\ 'merge':{
\   'prompt': 'Merge> ',
\   'execute': 'echo system("{git} merge {branch}")',
\   'multiple': v:false,
\   'keymap': 'ctrl-e',
\   'required': ['branch'],
\   'confirm': v:true,
\ },
\}

let g:fzf_tag_actions = {
\ 'checkout': {
\   'prompt': 'Checkout> ',
\   'execute': 'echo system("{git} checkout {tag}")',
\   'multiple': v:false,
\   'keymap': 'enter',
\   'required': ['tag'],
\   'confirm': v:false,
\ },
\ 'create': {
\   'prompt': 'Create> ',
\   'execute': 'echo system("{git} tag {input}")',
\   'multiple': v:false,
\   'keymap': 'ctrl-n',
\   'required': ['input'],
\   'confirm': v:false,
\ },
\ 'delete': {
\   'prompt': 'Delete> ',
\   'execute': 'echo system("{git} branch -D {tag}")',
\   'multiple': v:true,
\   'keymap': 'ctrl-d',
\   'required': ['tag'],
\   'confirm': v:true,
\ },
\}
" fugitive end

" symbols-outline
nnoremap <silent> <leader>v :SymbolsOutline<CR>
" symbols-outline end

" vim-vsnip
let g:vsnip_snippet_dir = '~/.config/nvim/vsnip'
" vim-vsnip end

" indent-blankline
let g:indent_blankline_filetype = ['vim', 'lua', 'python']
" indent-blankline end

" vim-ultest
augroup UltestRunner
    au!
    au BufWritePost * UltestNearest
augroup END
" vim-ultest end

" vim-matchup
let g:matchup_surround_enabled = 1
let g:matchup_transmute_enabled = 1
" vim-matchup end

" minimap.vim
let g:minimap_width = 10
let g:minimap_auto_start = 0
let g:minimap_auto_start_win_enter = 0
" minimap.vim end

" vim-signify
nnoremap <leader>sd :SignifyDisable<CR>
" vim-signify end

" zen-mode
lua << EOF
  require("zen-mode").setup {}
EOF
" zen-mode end

" vim-rooter
let g:rooter_patterns = [
\ '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json',
\ 'tox.ini'
\]
" vim-rooter end
