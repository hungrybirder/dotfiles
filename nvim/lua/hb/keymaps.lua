-- temp file
vim.cmd([[

for f in split(glob('~/.config/nvim/plugins.d/*.vim'), '\n')
	exe 'source' f
endfor

" let s:load_dir = expand('<sfile>:p:h')
" exec printf('luafile %s/lua/init.lua', s:load_dir)

" set nocompatible

" for lsp debug
" lua << EOF
" vim.lsp.set_log_level("debug")
" EOF


" settings
syntax on
filetype plugin indent on

set inccommand=nosplit
" set list listchars=tab:› ,eol:↴,trail:•
set exrc
set number relativenumber
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
set undodir=~/.config/nvim_undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menu,menuone,noselect
set mouse=
set splitright
set splitbelow
set nobackup
set nowritebackup
" set colorcolumn=80
set signcolumn=yes

set cmdheight=1
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

" Navigating in Command Mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>


" 更新括号里的内容，非常有用
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap il[ :<c-u>normal! F]vi[<cr>
onoremap in< :<c-u>normal! f<vi<<cr>
onoremap il< :<c-u>normal! F>vi<<cr>

nnoremap <leader>u :UndotreeToggle<CR>

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

if executable('rg')
    let g:rg_derive_root='true'
endif
let loaded_matchparen = 1

"https://github.com/fatih/vim-go/issues/108#issuecomment-47450678
" autocmd FileType qf wincmd J
autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
" close quickfix
" noremap <silent> <space>q :<C-U>cclose<CR>

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
" nnoremap <s-tab> za
" nnoremap <leader>z :call ToggleFold()<CR>
func! ToggleFold()
    if &foldlevel == 0
        set foldlevel=99
        echo 'unfold'
    else
        set foldlevel=0
        echo 'fold'
    endif
endfunc

" Disable F1
nmap <F1> <nop>
imap <F1> <nop>

" plugin mappings

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

if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

" vim-visual-multi
let g:VM_leader = '\\'
" vim-visual-multi end

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

" indent-blankline
let g:indent_blankline_filetype = ['vim', 'lua', 'python']
" indent-blankline end

" vim-matchup
let g:matchup_surround_enabled = 1
let g:matchup_transmute_enabled = 1
" vim-matchup end

" vim-rooter
let g:rooter_patterns = [
\ '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json',
\ 'tox.ini'
\]
" vim-rooter end

" nvim-jdtls
augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require'hb/lsp/langservers'.setup_jdtls()
augroup end
" nvim-jdtls end

augroup codelens
  autocmd!
  autocmd BufWritePost *.java lua vim.lsp.codelens.refresh()
augroup END

function! ToggleNumber()
    if(&number == 1 || &relativenumber == 1)
        set nonumber norelativenumber
    else
        set number relativenumber
    endif
endfunction

]])
