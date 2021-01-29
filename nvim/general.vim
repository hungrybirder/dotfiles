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
set completeopt=menuone,noinsert,noselect
set colorcolumn=80
set signcolumn=yes

" Give more space for displaying messages.
set cmdheight=2
set timeout ttimeout
set timeoutlen=500  " Time out on mappings
set updatetime=50   " Idle time to write swap and trigger CursorHold
set ttimeoutlen=10  " Time out on key codes

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set clipboard& clipboard+=unnamed

set grepprg=rg

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
map <c-d> dd
" delete current line in Insert Mode
imap <c-d> <esc>ddi
" exit insert mode
inoremap jk <esc>

" Keep search matches in the middle of the window.
" nnoremap n nzzzv
" nnoremap N Nzzzv

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

" greatest remap ever
vnoremap <leader>p "_dP

" next greatest remap ever : asbjornHaland
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

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
" https://github.com/fatih/vim-go/issues/108#issuecomment-47450678
autocmd FileType qf wincmd J
" close quickfix
noremap <silent> <space>q :<C-U>cclose<CR>
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
