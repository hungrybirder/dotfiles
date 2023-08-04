-- temp file
vim.cmd([[

for f in split(glob('~/.config/nvim/plugins.d/*.vim'), '\n')
	exe 'source' f
endfor

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
    let g:rg_derive_root='true'
endif

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

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

" vim-test
" function! DebugNearest()
"   let g:test#go#runner = 'delve'
"   TestNearest
"   unlet g:test#go#runner
" endfunction

" nnoremap <silent> td :call DebugNearest()<CR>
" nnoremap <silent> tt :TestNearest<CR>
" nnoremap <silent> tf :TestFile<CR>
" nnoremap <silent> ts :TestSuite<CR>
" nnoremap <silent> t_ :TestLast<CR>
" let test#strategy = "neovim"
" let test#neovim#term_position = "rightbelow"

" vim-subversive
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" <leader>s<motion1><motion2>
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)

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

let g:rooter_patterns = [
\ '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json',
\ 'tox.ini'
\]

function! ToggleNumber()
    if(&number == 1 || &relativenumber == 1)
        set nonumber norelativenumber
    else
        set number relativenumber
    endif
endfunction

]])
