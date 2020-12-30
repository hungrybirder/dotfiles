call plug#begin('~/.config/nvim/plugged')

" marks
Plug 'kshenoy/vim-signature'
Plug 'rhysd/clever-f.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'moll/vim-bbye'

Plug 'tweekmonster/startuptime.vim'
Plug 'tpope/vim-surround'

Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Neovim lsp Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tjdevries/nlua.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'steelsojka/completion-buffers'


" nvim Tree Sitter NBNBNB
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/completion-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'


Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'mbbill/undotree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'lifepillar/vim-gruvbox8'

" Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" telescope requirements...
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-vimspector.nvim'

" code snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'preservim/tagbar'


" auto format
Plug 'sbdchd/neoformat'

" comment
Plug 'tomtom/tcomment_vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" langs
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
call plug#end()


fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun

" Debugger remaps
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         12,
  \    'vimspectorBPCond':     11,
  \    'vimspectorBPDisabled': 10,
  \    'vimspectorPC':         999,
  \ }

nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
" nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
" nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
" nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
" nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
" nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
" nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>
"
" nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>
"
" nmap <leader>dl <Plug>VimspectorStepInto
" nmap <leader>dj <Plug>VimspectorStepOver
" nmap <leader>dk <Plug>VimspectorStepOut
" nmap <leader>d_ <Plug>VimspectorRestart
" nnoremap <leader>d<space> :call vimspector#Continue()<CR>
"
" nmap <leader>drc <Plug>VimspectorRunToCursor
" nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
" nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint

" <Plug>VimspectorStop
" <Plug>VimspectorPause
" <Plug>VimspectorAddFunctionBreakpoint

nnoremap <silent> <leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-]> :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>i :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>sh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>sd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent><leader>j <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent><leader>k <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

nnoremap <leader>f :lua require('telescope').extensions.fzf_writer.files()<CR>
nnoremap <leader>o :Telescope treesitter<CR>
nnoremap <leader>b :Telescope buffers<CR>
nnoremap <leader>a :Telescope live_grep<CR>
nnoremap <leader>r :Telescope lsp_references<CR>
nnoremap <c-p> :Telescope git_files<CR>

nnoremap <leader>gh :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>ga :Git fetch --all<CR>
fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

let g:neoformat_enabled_python = ['yapf']
let g:neoformat_enabled_go = ['goimports']
let g:neoformat_enabled_ruby = ['']
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

let g:completion_enable_snippet = 'UltiSnips'
let g:completion_confirm_key = "\<C-y>"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_ignore_case = 1

let g:indicator_errors = "\uf05e "
let g:indicator_warnings = "\uf071 "
let g:indicator_infos = "\uf7fc "
let g:indicator_hints = "\ufbe6 "

call sign_define("LspDiagnosticsSignError", {"text" : g:indicator_errors, "texthl" : "LspDiagnosticsDefaultError"})
call sign_define("LspDiagnosticsSignWarning", {"text" : g:indicator_warnings, "texthl" : "LspDiagnosticsDefaultWarning"})
call sign_define("LspDiagnosticsSignInformation", {"text" : g:indicator_infos, "texthl" : "LspDiagnosticsDefaultInformation"})
call sign_define("LspDiagnosticsSignHint", {"text" : g:indicator_hints, "texthl" : "LspDiagnosticsDefaultHint"})

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"

inoremap <silent> <C-Space> <cmd>lua require'completion'.triggerCompletion()<CR>
inoremap <tab> <cmd>lua require'completion'.smart_tab()<CR>

autocmd Filetype markdown,make lua require'completion'.on_attach()

let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

noremap <Leader>pi :<c-u>PlugInstall<CR>
noremap <Leader>pu :<c-u>PlugUpdate<CR>
noremap <Leader>pc :<c-u>PlugClean<CR>


func! EnableEchoDoc()
  call echodoc#enable()
  if has('nvim')
    let g:echodoc#type = "floating"
    highlight link EchoDocFloat Pmenu
  else
    let g:echodoc#type = "popup"
    highlight link EchoDocPopup Pmenu
  endif
endfun

augroup MyEchoDoc
  autocmd!
  autocmd FileType go call EnableEchoDoc()
augroup END

let g:go_gopls_enabled = 0

" clever-f {{{
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
" }}}

" auto-pairs {{{
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle = '<leader>3'
" auto-pairs }}}

" vim-bbye {{{
noremap <leader><BS> :Bdelete<cr>
" vim-bbye }}}

" nerdtree {{{
let NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI=1
map <leader><tab> :<c-u>NERDTreeToggle<CR>
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
" nerdtree}}}

" tagbar {{{
nnoremap <silent> <leader>2 :TagbarToggle<CR>
let tags = "./tags"
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
"tagbar }}}
