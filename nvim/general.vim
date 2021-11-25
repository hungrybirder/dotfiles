syntax on
filetype plugin indent on

set list listchars=tab:› ,eol:¬,trail:•
set exrc
set guicursor=
set number relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menu,menuone,noselect
" set mouse=a
set splitright
set splitbelow
set nobackup
set nowritebackup
set colorcolumn=80
set signcolumn=yes

" Give more space for displaying messages.
set cmdheight=2
set timeout ttimeout
set timeoutlen=500  " Time out on mappings
set updatetime=100   " Idle time to write swap and trigger CursorHold
set ttimeoutlen=10  " Time out on key codes

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set clipboard=unnamedplus

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

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

nnoremap <c-h> :wincmd h<CR>
nnoremap <c-j> :wincmd j<CR>
nnoremap <c-k> :wincmd k<CR>
nnoremap <c-l> :wincmd l<CR>

" ctrl_e ctrl_y 3 lines
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>
vnoremap <c-e> 3<c-e>
vnoremap <c-y> 3<c-y>

" delete current line
" map <c-d> dd
" delete current line in Insert Mode
" imap <c-d> <esc>ddi
" exit insert mode
inoremap jk <esc>

" Keep search matches in the middle of the window.
" nnoremap n nzzzv
" nnoremap N Nzzzv

" 更新括号里的内容，非常有用
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap il[ :<c-u>normal! F]vi[<cr>
onoremap in< :<c-u>normal! f<vi<<cr>
onoremap il< :<c-u>normal! F>vi<<cr>


nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize +2<CR>
nnoremap <M-k>    :resize -2<CR>
nnoremap <M-h>    :vertical resize +2<CR>
nnoremap <M-l>    :vertical resize -2<CR>

" Best remap by ThePrimeagen
" greatest remap ever
vnoremap <leader>p "_dP

" next greatest remap ever : asbjornHaland
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Behave Vim
nnoremap Y y$

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Moving text
" not pollute registers!
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" inoremap <C-k> <esc>:m .-2<CR>==
" inoremap <C-j> <esc>:m .+1<CR>==
" nnoremap <leader>j :m .+1<CR>==
" nnoremap <leader>k :m .-2<CR>==

" Best remap by ThePrimeagen Done

" Switch to alternative buffer
nnoremap <bs> <c-^>

inoremap <C-c> <esc>

" Q: Closes the window
nnoremap Q :q<cr>
" close all windows
nnoremap <leader>Q :qa!<cr>

augroup line_return
  au!
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   execute 'normal! g`"zvzz' |
    \ endif
augroup END

if executable('rg')
    let g:rg_derive_root='true'
endif
let loaded_matchparen = 1

" quickfix

" https://github.com/tpope/vim-unimpaired/issues/97
function! ToggleQuickfixWindow()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction
noremap <silent> <space>q :<C-U>call ToggleQuickfixWindow()<CR>

"https://github.com/fatih/vim-go/issues/108#issuecomment-47450678
autocmd FileType qf wincmd J
" close quickfix
" noremap <silent> <space>q :<C-U>cclose<CR>

" close loclist
noremap <silent> <space>l :<C-U>lclose<CR>
" quickfix end

" powered by ThePrimeagen
fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

" powered by ThePrimeagen
fun! TrimWhitespace()
    " 删除每行多余的空格
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup MY_FILETYPE
  au!
  autocmd BufWritePre * :call TrimWhitespace()

  autocmd FileType vim setlocal ts=2 sts=2 sw=2 et
  autocmd FileType sh setlocal ts=4 sts=4 sw=4 et
augroup end


" Folding setup
set foldenable
set foldmethod=indent
set foldlevelstart=99
" See https://github.com/nvim-treesitter/nvim-treesitter/pull/390#issuecomment-709666989
function! GetSpaces(foldLevel)
  if &expandtab == 1
    " Indenting with spaces
    let str = repeat(" ", a:foldLevel / (&shiftwidth + 1) - 1)
    return str
  elseif &expandtab == 0
    " Indenting with tabs
    return repeat(" ", indent(v:foldstart) - (indent(v:foldstart) / &shiftwidth))
  endif
endfunction

function! MyFoldText()
  let startLineText = getline(v:foldstart)
  let endLineText = trim(getline(v:foldend))
  let indentation = GetSpaces(foldlevel("."))
  let spaces = repeat(" ", 200)

  let str = indentation . startLineText . "..." . endLineText . spaces

  return str
endfunction
set foldtext=MyFoldText()
nnoremap <s-tab> za

map <leader>z :call ToggleFold()<CR>
func! ToggleFold()
    if &foldlevel == 0
        set foldlevel=99
        echo 'unfold'
    else
        set foldlevel=0
        echo 'fold'
    endif
endfunc

" Nvim specifics
" Shows realtime changes with :s/
set inccommand=split

" Disable F1
nmap <F1> <nop>
imap <F1> <nop>
