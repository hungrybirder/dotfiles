set nocompatible

" plugins {{{
call plug#begin('~/.config/nvim/plugged')

" deoplete framework {{{
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neco-vim' " vimscripts for deoplete complete
" deoplete framework }}}

" snippet framework
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/tComment'
Plug 'NLKNguyen/papercolor-theme'
Plug 'bling/vim-airline'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'rbgrouleff/bclose.vim'
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
Plug 'qpkorr/vim-bufkill'
Plug 'cespare/vim-toml'
Plug 'hotoo/pangu.vim' " 中文排版
call plug#end() " }}}

" general {{{
syntax enable

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

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
  set clipboard& clipboard+=unnamedplus
endif
""
set nofoldenable
set relativenumber
set magic
set hlsearch
set pastetoggle=<F6>
set grepprg=rg
set t_Co=256
set background=dark
colorscheme PaperColor

set dictionary+=/usr/share/dict/words
set lazyredraw
set showcmd
set gfn=Monaco:h18
set history=1000

set noexpandtab     " Don't expand tabs to spaces.
set tabstop=2       " The number of spaces a tab is
set softtabstop=2   " While performing editing operations
set shiftwidth=2    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

set timeout ttimeout
set timeoutlen=750  " Time out on mappings
set updatetime=400  " Idle time to write swap and trigger CursorHold
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
noremap <F1> <nop>
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" mappings }}}

" snippets {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsListSnippets="<leader><enter>"
let g:UltiSnipsEditSplit="vertical"
" snippets }}}

" airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#fnamemod = ':t' " only show buffer name
let g:airline_theme = "dark"
" airline }}}

" align {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" align }}}

" autopairs {{{
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle = '<F4>'
" autopairs }}}

" bufkill {{{
map <C-c> :BD<cr>
" bufkill }}}

" denite {{{
try
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
  " Use ripgrep in place of "grep"
  call denite#custom#var('grep', 'command', ['rg'])
  " Custom options for ripgrep
  "   --vimgrep:  Show results with every match on it's own line
  "   --hidden:   Search hidden directories and files
  "   --heading:  Show the file name above clusters of matches from each file
  "   --S:        Search case insensitively if the pattern is all lowercase
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])
  " Recommended defaults for ripgrep via Denite docs
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')
  " Custom options for Denite
  "   auto_resize             - Auto resize the Denite window height automatically.
  "   prompt                  - Customize denite prompt
  "   direction               - Specify Denite window direction as directly below current pane
  "   winminheight            - Specify min height for Denite window
  "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
  "   prompt_highlight        - Specify color of prompt
  "   highlight_matched_char  - Matched characters highlight
  "   highlight_matched_range - matched range highlight
  let s:denite_options = {'default' : {
  \ 'split': 'floating',
  \ 'start_filter': 1,
  \ 'auto_resize': 0,
  \ 'prompt': '> ',
  \ 'statusline': 0,
  \ 'highlight_matched_char': 'QuickFixLine',
  \ 'highlight_matched_range': 'Visual',
  \ 'highlight_window_background': 'Visual',
  \ 'highlight_filter_background': 'DiffAdd',
  \ 'winrow': 1,
  \ 'vertical_preview': 1
  \ }}
  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction
  call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry
" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" FIND and GREP COMMANDS
if executable('rg')
  " Ripgrep
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
endif " }}}

" deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
" deoplete }}}

" vim-multiple-cursors {{{
let g:multi_cursor_exit_from_insert_mode = 0
let g:multi_cursor_exit_from_visual_mode = 0

function! Multiple_cursors_before()
  if deoplete#is_enabled()
    call deoplete#disable()
    let g:deoplete_is_enable_before_multi_cursors = 1
  else
    let g:deoplete_is_enable_before_multi_cursors = 0
  endif
endfunction

function! Multiple_cursors_after()
  if g:deoplete_is_enable_before_multi_cursors
    call deoplete#enable()
  endif
endfunction
" vim-multiple-cursors }}}

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

" autogroup go {{{
augroup go
  autocmd!
  autocmd FileType go nmap <silent> <Leader>V <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>S <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>D <Plug>(go-def-tab)

  autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)

  autocmd FileType go nmap <silent> <Leader>I <Plug>(go-info)
  autocmd FileType go nmap <silent> <Leader>L <Plug>(go-metalinter)

  autocmd FileType go nmap <silent> <leader>T  <Plug>(go-test)
  " autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
  " autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

  autocmd FileType go nmap <silent> <Leader>C <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <silent> <leader>B :<C-u>call <SID>build_go_files()<CR>
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  autocmd FileType go noremap <buffer><Leader>cf :GoFmt<CR><CR>
  autocmd FileType go inoremap <buffer><Leader>cf <c-c>:GoFmt<CR><CR>gi
augroup END
" autogroup go }}}
