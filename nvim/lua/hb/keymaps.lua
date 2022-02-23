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
set list listchars=tab:› ,eol:↴,trail:•
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
set undodir=~/.config/nvim_undodir
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
" autocmd FileType qf wincmd J
autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
" close quickfix
" noremap <silent> <space>q :<C-U>cclose<CR>

function! s:BufferCount() abort
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

" Location list
" Toggle Location List window
function! ToggleLocationList()
  " https://github.com/Valloric/ListToggle/blob/master/plugin/listtoggle.vim
  let buffer_count_before = s:BufferCount()

  " Location list can't be closed if there's cursor in it, so we need
  " to call lclose twice to move cursor to the main pane
  silent! lclose
  silent! lclose

  if s:BufferCount() == buffer_count_before
    lopen
  endif
endfunction

nnoremap <silent> <space>l :call ToggleLocationList()<cr>

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

]])

local hb_utils = require("hb/utils")
local remap = hb_utils.remap
local opts = hb_utils.opt_noremap_silent
local opt_noremap = hb_utils.opt_noremap

vim.g.mapleader = " "

remap("n", "<leader>ev", "<cmd>e $MYVIMRC<CR>", opt_noremap)
remap("n", "<leader>sv", "<cmd>so $MYVIMRC<CR>", opt_noremap)

remap("n", "<leader>pi", "<cmd>PackerSync<CR>", opt_noremap)
remap("n", "<leader>pu", "<cmd>PackerUpdate<CR>", opt_noremap)
remap("n", "<leader>pc", "<cmd>PackerClean<CR>", opt_noremap)

-- neoterm
-- vim.g.neoterm_default_mod = 'vertical'
-- vim.g.neoterm_size = 60
-- vim.g.neoterm_autoinsert = 1
-- vim.g.neoterm_term_per_tab = 1
-- vim.g.neoterm_repl_python = "ipython3"
-- remap('n', '<c-q>', '<cmd>Ttoggle<CR>', opts)
-- remap('i', '<c-q>', '<ESC>:Ttoggle<CR>', opts)
-- remap('t', '<c-q>', '<c-\\><c-n>:Ttoggle<CR>', opts)

vim.g.vim_markdown_math = true
remap("n", "<leader>md", "<cmd>MarkdownPreview<CR>", opts)

-- vim-bbye
remap("n", "<leader><BS>", "<cmd>Bdelete<CR>", opts)

-- Best remap by ThePrimeagen
-- greatest remap ever
remap("v", "<leader>p", '"_dP', opts)

remap("v", "<", "<gv", opts)
remap("v", ">", ">gv", opts)

-- inoremap maps a key combination for insert mode
-- <C-e> is the keybinding I am creating.
-- <C-o> is a command that switches vim to normal mode for one command.
-- $ jumps to the end of the line and we are switched back to insert mode.
remap("i", "<C-e>", "<C-o>$", opts)
remap("i", "<C-a>", "<C-o>0", opts)

-- next greatest remap ever : asbjornHaland
remap("n", "<leader>y", '"+y', opts)
remap("v", "<leader>y", '"+y', opts)
remap("n", "<leader>Y", 'gg"+yG', opts)

-- Behave Vim
remap("n", "Y", "y$", opts)

-- Moving text
-- not pollute registers!
remap("v", "J", ":m '>+1<CR>gv=gv", opts)
remap("v", "K", ":m '<-2<CR>gv=gv", opts)
-- inoremap <C-k> <esc>:m .-2<CR>==
-- inoremap <C-j> <esc>:m .+1<CR>==
-- nnoremap <leader>j :m .+1<CR>==
-- nnoremap <leader>k :m .-2<CR>==

-- Switch to alternative buffer
remap("n", "<bs>", "<c-^>", opts)

remap("n", "<C-c>", "<esc>", opts)

-- Q: Closes the window
remap("n", "Q", "<cmd>q<CR>", opts)
-- close all windows
remap("n", "<leader>Q", "<cmd>qa!<CR>", opts)

-- Undo break points
remap("i", ",", ",<c-g>u", opts)
remap("i", ".", ".<c-g>u", opts)
remap("i", "!", "!<c-g>u", opts)
remap("i", "?", "?<c-g>u", opts)

-- Keeping it centered
remap("n", "n", "nzzzv", opts)
remap("n", "N", "Nzzzv", opts)
remap("n", "J", "mzJ`z", opts)

-- Use alt + hjkl to resize windows
remap("n", "<M-j>", ":resize +2<CR>", opts)
remap("n", "<M-k>", ":resize -2<CR>", opts)
remap("n", "<M-h>", ":vertical resize +2<CR>", opts)
remap("n", "<M-l>", ":vertical resize -2<CR>", opts)

-- delete current line
-- map <c-d> dd
-- delete current line in Insert Mode
-- imap <c-d> <esc>ddi
-- exit insert mode
-- inoremap jk <esc>
remap("i", "jk", "<esc>", opts)

-- Move to window
remap("n", "<c-h>", "<cmd>wincmd h<CR>", opts)
remap("n", "<c-j>", "<cmd>wincmd j<CR>", opts)
remap("n", "<c-k>", "<cmd>wincmd k<CR>", opts)
remap("n", "<c-l>", "<cmd>wincmd l<CR>", opts)
--
-- ctrl_e ctrl_y 3 lines
remap("n", "<c-e>", "3<c-e>", opts)
remap("n", "<c-y>", "3<c-y>", opts)
remap("v", "<c-e>", "3<c-e>", opts)
remap("v", "<c-y>", "3<c-y>", opts)
