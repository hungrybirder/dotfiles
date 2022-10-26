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

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ev", "<cmd>e $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>sv", "<cmd>so $MYVIMRC<CR>")

-- packer
vim.keymap.set("n", "<leader>pi", "<cmd>PackerSync<CR>")
vim.keymap.set("n", "<leader>pu", "<cmd>PackerUpdate<CR>")
vim.keymap.set("n", "<leader>pc", "<cmd>PackerClean<CR>")

vim.g.vim_markdown_math = true
vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreview<CR>")

-- vim-bbye
vim.keymap.set("n", "<leader><BS>", "<cmd>Bdelete<CR>")

-- Best remap by ThePrimeagen
-- greatest remap ever
vim.keymap.set("v", "<leader>p", '"_dP')

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- inoremap maps a key combination for insert mode
-- <C-e> is the keybinding I am creating.
-- <C-o> is a command that switches vim to normal mode for one command.
-- $ jumps to the end of the line and we are switched back to insert mode.
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-a>", "<C-o>0")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", 'gg"+yG')

-- Behave Vim
vim.keymap.set("n", "Y", "y$")

-- Moving text
-- not pollute registers!
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- inoremap <C-k> <esc>:m .-2<CR>==
-- inoremap <C-j> <esc>:m .+1<CR>==
-- nnoremap <leader>j :m .+1<CR>==
-- nnoremap <leader>k :m .-2<CR>==

-- Switch to alternative buffer
vim.keymap.set("n", "<bs>", "<c-^>")

vim.keymap.set("n", "<C-c>", "<esc>")

-- Q: Closes the window
-- remap("n", "Q", "<cmd>q<CR>", opts)
vim.keymap.set("n", "Q", "<cmd>q<CR>")
-- close all windows
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>")

-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")

-- Keeping it centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")

-- Use alt + hjkl to resize windows
vim.keymap.set("n", "<M-j>", ":resize +2<CR>")
vim.keymap.set("n", "<M-k>", ":resize -2<CR>")
vim.keymap.set("n", "<M-h>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<M-l>", ":vertical resize -2<CR>")

-- delete current line
-- map <c-d> dd
-- delete current line in Insert Mode
-- imap <c-d> <esc>ddi
-- exit insert mode
-- inoremap jk <esc>
vim.keymap.set("i", "jk", "<esc>")

-- Move to window
vim.keymap.set("n", "<c-h>", "<cmd>wincmd h<CR>")
vim.keymap.set("n", "<c-j>", "<cmd>wincmd j<CR>")
vim.keymap.set("n", "<c-k>", "<cmd>wincmd k<CR>")
vim.keymap.set("n", "<c-l>", "<cmd>wincmd l<CR>")
--
-- ctrl_e ctrl_y 3 lines
vim.keymap.set("n", "<c-e>", "3<c-e>")
vim.keymap.set("n", "<c-y>", "3<c-y>")
vim.keymap.set("v", "<c-e>", "3<c-e>")
vim.keymap.set("v", "<c-y>", "3<c-y>")

vim.o.hlsearch = true
vim.keymap.set("n", "<esc><esc>", "<cmd>nohlsearch<CR>")

-- map toggle number
vim.keymap.set("n", "<leader>N", "<cmd>call ToggleNumber()<CR>")

-- tmuxjump
vim.g.tmuxjump_telescope = 1
vim.keymap.set("n", "<leader>ft", "<cmd>TmuxJumpFile<CR>")

-- Reselect pasted text
-- From https://vimtricks.com/p/reselect-pasted-text/
vim.keymap.set("n", "gp", "`[v`]")

-- folder mappings
vim.keymap.set("n", "<leader>z", ":call ToggleFold()<CR>")
vim.keymap.set("n", "<s-tab>", "za")
