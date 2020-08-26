set nocompatible

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

" deoplete framework {{{
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neco-vim' " vimscripts for deoplete complete
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'AndrewRadev/splitjoin.vim' "gS gJ
Plug 'deoplete-plugins/deoplete-jedi' " py for deoplete
Plug 'davidhalter/jedi-vim'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neoinclude.vim'
Plug 'deoplete-plugins/deoplete-tag'
Plug 'Shougo/deoplete-clangx'
Plug 'ncm2/float-preview.nvim'

" Plug 'leafgarland/typescript-vim'
" Plug 'HerringtonDarkholme/yats.vim' " for ts syntax file
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" deoplete framework }}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'airblade/vim-rooter'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh'}
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh', 'tag':'v1.22' }
Plug 'majutsushi/tagbar'
Plug 'preservim/nerdtree'

" auto format plugin
Plug 'sbdchd/neoformat'

" code syntax check
Plug 'dense-analysis/ale'

" snippet framework
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'ervandew/supertab'

Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/tComment'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
" Plug 'bling/vim-bufferline'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'moll/vim-bbye'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" 变更的跳转
" ]c   Jump to next hunk.
" [c   Jump to previous hunk.
" ]C   Jump to last hunk.
" [C   Jump to first hunk.
Plug 'mhinz/vim-signify'
Plug 'jamessan/vim-gnupg'
Plug 'jiangmiao/auto-pairs'
Plug 'cespare/vim-toml'
Plug 'hotoo/pangu.vim' " 中文排版
Plug 'avakhov/vim-yaml'

" for markdown
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'iamcco/mathjax-support-for-mkdp'

" easymotion
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'

Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'

" Language packs
Plug 'sheerun/vim-polyglot'
call plug#end() " }}}

" general {{{
syntax enable

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   execute 'normal! g`"zvzz' |
    \ endif
augroup END
" general }}}


" setting {{{
set list listchars=tab:› ,eol:¬,trail:•
set backspace=indent,eol,start
set laststatus=2
set maxmempattern=5000
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set hidden
set wildmenu
set wildmode=longest:full,full
if has('mac')
  let g:clipboard = {
    \   'name': 'macOS-clipboard',
    \   'copy': {
    \      '+': 'pbcopy',
    \      '*': 'pbcopy',
    \    },
    \   'paste': {
    \      '+': 'pbpaste',
    \      '*': 'pbpaste',
    \   },
    \   'cache_enabled': 0,
    \ }
endif

if has('clipboard')
  set clipboard& clipboard+=unnamed
endif
""
set nofoldenable
set number relativenumber
set magic
set hlsearch
set pastetoggle=<F6>
set grepprg=rg
set t_Co=256

let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

set background=dark
colorscheme gruvbox

set dictionary+=/usr/share/dict/words
set lazyredraw
set showcmd
set gfn=Monaco:h18
set history=1000

set expandtab
set tabstop=4       " The number of spaces a tab is
set softtabstop=4   " While performing editing operations
set shiftwidth=4    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

set timeout ttimeout
set timeoutlen=500  " Time out on mappings
set updatetime=100  " Idle time to write swap and trigger CursorHold
set ttimeoutlen=10  " Time out on key codes

set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set showfulltag     " Show tag and tidy search in completion
set noerrorbells
set nowrap
set noswapfile
set nobackup
set undofile
set undodir=~/.config/nvim/undodir

" set splitbelow
set splitright
" setting }}}

" mappings {{{
nnoremap <F3> :let @/ = ""<CR>
" Q: Closes the window
nnoremap Q :q<cr>
" close all windows
nnoremap <leader>Q :qa!<cr>
" Act like D and C
nnoremap Y y$
" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv
" easy move around windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
" ctrl_e ctrl_y 3 lines
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>
vnoremap <c-e> 3<c-e>
vnoremap <c-y> 3<c-y>

" 单个word加双引号
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" visually selected加双引号
vnoremap <leader>" :normal! `<i"<esc>`>la"<esc>"

" Ctrl-r: Easier search and replace
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>
" sort
vnoremap <leader>s :sort<cr>
" easy move code blocks
vnoremap < <gv
vnoremap > >gv
" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv

"inoremap maps a key combination for insert mode
"<C-e> is the keybinding I am creating.
"<C-o> is a command that switches vim to normal mode for one command.
"$ jumps to the end of the line and we are switched back to insert mode.
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

" Navigating in Command Mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" When you forgot to open vim with sudo, use w!!
cmap w!! w !sudo tee > /dev/null %

"Insert Mode move word forward and backward
inoremap <c-b> <c-\><c-O>b
inoremap <c-f> <c-\><c-O>w

" Calculate from current line
nnoremap <leader>ca yypkA<Esc>jOscale=2<Esc>:.,+1!bc<CR>kdd

" delete current line
map <c-d> dd
" delete current line in Insert Mode
imap <c-d> <esc>ddi

map <c-u> viwU
" convert the current work to uppercase in Insert Mode
imap <c-u> <esc>viwUea

" exit insert mode
inoremap jk <esc>

" 更新括号里的内容，非常有用
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>

" 保存
nnoremap <c-s> :<c-u>update<cr>
inoremap <c-s> <c-o>:update<cr>
vnoremap <c-s> <esc>:update<cr>gv

" disable F1
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
" mappings }}}

" supertab && snippets {{{
let g:SuperTabDefaultCompletionType = "<c-n>"
" tab 是非常重要的，即做补充选择又做ultisnip展开
" 使用了 deoplete omni_patterns 不需要下面两行了
" let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:UltiSnipsExpandTrigger="<tab>"
" 使用<c-j> <c-k> 做 Jump Forward Backward
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" supertab && snippets }}}

" lightline {{{
let g:lightline = {'colorscheme': 'wombat'}
let g:lightline.component_expand = {
  \  'linter_checking': 'lightline#ale#checking',
  \  'linter_infos': 'lightline#ale#infos',
  \  'linter_warnings': 'lightline#ale#warnings',
  \  'linter_errors': 'lightline#ale#errors',
  \  'linter_ok': 'lightline#ale#ok',
  \ }
let g:lightline.component_type = {
  \  'linter_checking': 'right',
  \  'linter_infos': 'right',
  \  'linter_warnings': 'warning',
  \  'linter_errors': 'error',
  \  'linter_ok': 'right',
  \ }
let g:lightline.active = { 'right': [[
  \ 'linter_checking',
  \ 'linter_errors',
  \ 'linter_warnings',
  \ 'linter_infos',
  \ 'linter_ok' ],
  \ ['lineinfo'], ['percent'],
  \ ['fileencoding', 'filetype'],
  \]
  \ }
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"
" lightline}}}

" align {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" align }}}

" autopairs {{{
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle = '<F4>'
" autopairs }}}

" vim-bbye {{{
noremap <space><BS> :Bdelete<cr>
" vim-bbye }}}

" float-preview {{{
let g:float_preview#docked = 0
"float-preview }}}

" neoformat {{{
let g:neoformat_enabled_python = ['autopep8']
" neoformat }}}

" ale {{{
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:ale_linters = {
\ 'python':['pylint'],
\ 'javascript':['eslint'],
\ 'typescript':['eslint', 'tsserver'],
\ 'java':[],
\ 'go': ['gofmt', 'golint', 'go vet']
\ }
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'python': ['yapf'],
\ 'go': ['gofmt'],
\ 'javascript':['eslint'],
\ 'typescript':['eslint'],
\ }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%code%] %s [%severity%]'
let g:ale_lint_on_enter = 1
let g:ale_fix_on_save = 1
nmap <silent> <space>j <Plug>(ale_next_wrap)
nmap <silent> <space>k <Plug>(ale_previous_wrap)

" ale }}}

" markdown {{{
let g:vim_markdown_math = 1
nmap <leader>md :MarkdownPreview<CR>
" markdown }}}
" deoplete {{{
let g:deoplete#enable_at_startup = 1
" 设置 omni_patterns, 这样deoplete=>go#complete#Complete(vim-go)=>gopls
" 不再依赖deoplete-go(依赖gocode)
set completeopt+=noselect
call deoplete#custom#option('omni_patterns', {
\ 'go': '[^. *\t]\.\w*',
\})
call deoplete#custom#option({
\ 'auto_complete_delay': 0,
\ 'smart_case': v:true,
\ 'refresh_always': v:false,
\ })
" deoplete }}}

" deoplete-jedi & jedi {{{
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0
let g:jedi#usages_command = "<space>r"
" deoplete-jedi & jedi }}}

" vim-multiple-cursors {{{
let g:multi_cursor_exit_from_insert_mode = 0
let g:multi_cursor_exit_from_visual_mode = 0

function! Multiple_cursors_before()
  if deoplete#is_enabled()
    call deoplete#disable()
    let g:deoplete_is_enable_before_multi_cursors = 1
    call ale#toggle#Disable()
    call echodoc#disable()
  else
    let g:deoplete_is_enable_before_multi_cursors = 0
  endif
endfunction

function! Multiple_cursors_after()
  if g:deoplete_is_enable_before_multi_cursors
    call deoplete#enable()
    call ale#toggle#Enable()
    call echodoc#enable()
  endif
endfunction
" vim-multiple-cursors }}}

" leaderf {{{
let g:Lf_StlColorscheme = 'gruvbox_material'
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseMemoryCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
" <C-X> open in horizontal split window
" <C-]> open in vertical split window
" <C-T> open in new tabpage
noremap <silent> <space>f :<C-U>LeaderfFile<CR>
noremap <silent> <space>m :<C-U>LeaderfMru<CR>
noremap <silent> <space>l :<C-U>LeaderfLine<CR>
noremap <silent> <space>o :<C-U>LeaderfFunction<CR>
noremap <silent> <space>b :<C-U>LeaderfBuffer<CR>
noremap <silent> <space>t :<C-U>LeaderfBufTagAll<CR>
noremap <silent> <space>T :<C-U>LeaderfTag<CR>
noremap <silent> <space>w :<C-U>LeaderfWindow<CR>
noremap <silent> <F1> :<C-U>LeaderfHelp<CR>
noremap <silent> <F12> :<C-U>LeaderfFunctionAll<CR>
noremap <silent> <space>a :<C-U><C-R>=printf("Leaderf rg %s", "")<CR><CR>
" close quickfix
noremap <silent> <space>c :<C-U>cclose<CR>

" gtags
" brew install global
" pip3 install pygments
"" Leaderf gtags --update
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fr :<C-U><C-R>=printf("Leaderf gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <space>n :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <space>p :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
"leaderf }}}

" fzf {{{
" noremap <silent> <F1> :<C-U>Helptags<CR>
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
nnoremap <C-p> :GFiles<CR>
let g:fzf_action = {
  \ 'ctrl-x': 'split',
  \ 'ctrl-]': 'vsplit' }
" fzf }}}


" tagbar {{{
nnoremap <silent> <leader>2 :TagbarToggle<CR>
let tags = "./tags"
"tagbar }}}

" nerdtree {{{
map <leader><tab> :<c-u>NERDTreeToggle<CR>
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" nerdtree}}}

" easymotion {{{
let g:EasyMotion_smartcase = 1
let g:incsearch#magic = '\v'
nmap s <Plug>(easymotion-overwin-f)
nmap t <Plug>(easymotion-t2)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" easymotion }}}

" echodoc {{{
let g:echodoc_enable_at_startup = 1
if has('nvim')
  let g:echodoc#type = "floating"
  highlight link EchoDocFloat Pmenu
else
  let g:echodoc#type = "popup"
  highlight link EchoDocPopup Pmenu
endif
" echodoc }}}

" Sweet Sweet FuGITive
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

" MyAutoCmd {{{
augroup MyAutoCmd
  au!
  filetype on
  " autocmd FileType python setlocal ts=4 sts=4 sw=4 et omnifunc=jedi#completions
  autocmd FileType python noremap <buffer><Leader>cf :Neoformat<CR><CR>
  autocmd FileType python inoremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>gi
  autocmd FileType python
        \ setlocal foldmethod=indent expandtab smarttab nosmartindent
        \ | setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType python set completeopt-=preview


  autocmd FileType vim setlocal ts=2 sts=2 sw=2 et

  autocmd FileType c set completeopt-=preview
  autocmd FileType cc,cpp set completeopt-=preview
  autocmd FileType cc,cpp noremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>gi
  autocmd FileType cc,cpp inoremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>gi
  autocmd FileType c setlocal ts=4 sts=4 sw=4 et
  autocmd FileType c nnoremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>gi
  autocmd FileType c inoremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>gi
  autocmd FileType cc,cpp setlocal ts=4 sts=4 sw=4 et

  autocmd FileType sh setlocal ts=4 sts=4 sw=4 et

  " java不做neomake
  " autocmd Filetype java NeomakeDisableBuffer

  " javascript
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2 et
  autocmd FileType javascript nnoremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>
  autocmd FileType javascript inoremap <buffer><Leader>cf <c-c>:Neoformat<CR><CR>gi

  autocmd FileType rst nnoremap <buffer><Leader>md <c-c>:InstantRst<CR>
  autocmd FileType rst inoremap <buffer><Leader>md <c-c>:InstantRst<CR>

  " 中文排版
  autocmd BufWritePre *.markdown,*.md,*.text,*.txt,*.wiki,*.cnx call PanGuSpacing()
augroup END
" MyAutoCmd }}}

" vim-go {{{
let g:go_test_prepend_name = 1
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_def_mode = "gopls"
" let g:go_implements_mode = 'gopls'
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 1
let g:go_auto_sameids = 0
let g:go_doc_popup_window = 1
let g:go_null_module_warning = 0
let g:go_echo_command_info = 1
let g:go_autodetect_gopath = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_enabled = ['vet', 'golint']
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 0
let g:go_highlight_operators = 1
let g:go_highlight_format_strings = 0
let g:go_highlight_function_calls = 0
let g:go_gocode_propose_source = 1
let g:go_addtags_transform = 'camelcase'
let g:go_fold_enable = []
let g:go_debug_windows = {
          \ 'vars':       'leftabove 30vnew',
          \ 'stack':      'leftabove 20new',
          \ 'goroutines': 'botright 10new',
          \ 'out':        'botright 5new',
\ }

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
" vim-go }}}

" autogroup go {{{
augroup go
  autocmd!
  autocmd FileType go nmap <silent> <Leader>V <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>S <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>D <Plug>(go-def-tab)
  autocmd FileType go nmap <silent> <Leader>d :<c-u>GoDef<cr>
  autocmd FileType go nmap <C-g> :GoDecls<cr>
  autocmd FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  autocmd FileType go nmap <space>g :GoDeclsDir<cr>
  autocmd FileType go nmap <space>o :<C-U>GoDecls<CR>
  autocmd FileType go nmap <space>r :<C-U>GoReferrers<CR>


  autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)

  autocmd FileType go nmap <silent> <Leader>I <Plug>(go-info)
  autocmd FileType go nmap <silent> <Leader>L <Plug>(go-metalinter)

  autocmd FileType go nmap <silent> <leader>T  <Plug>(go-test)
  " autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
  " autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

  autocmd FileType go nmap <silent> <Leader>C <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <silent> <leader>B :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <leader>4 :<C-u>GoTestFunc<CR>
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  autocmd FileType go noremap <buffer><Leader>cf :GoFmt<CR><CR>
  autocmd FileType go inoremap <buffer><Leader>cf <c-c>:GoFmt<CR><CR>gi
  autocmd FileType go setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType go setlocal completeopt-=preview
augroup END

" autogroup go }}}

" autogroup es {{{
" augroup typescript
"   autocmd FileType typescript nmap <silent> <Leader>d :TSDef<cr>
"   autocmd FileType typescript let g:ale_open_list = 1
" augroup END
" autogroup }}}
