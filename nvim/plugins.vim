call plug#begin('~/.config/nvim/plugged')

Plug 'liuchengxu/vim-which-key'
Plug 'airblade/vim-rooter'
Plug 'tweekmonster/startuptime.vim'

" theme
Plug 'lifepillar/vim-gruvbox8'

" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'akinsho/nvim-bufferline.lua'

" delete buffer without closing windows
Plug 'moll/vim-bbye'
" Delete all the buffers except the current buffer.
Plug 'schickling/vim-bufonly'

" speedup editing
Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'rhysd/clever-f.vim'

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

" powered by svermeulen
Plug 'svermeulen/vim-subversive'
" Plug 'svermeulen/vim-cutlass'
Plug 'svermeulen/vim-yoink'

" tagbar & nerdtree
Plug 'preservim/tagbar'
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tjdevries/nlua.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'steelsojka/completion-buffers'

" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/completion-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" sign marks
Plug 'kshenoy/vim-signature'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-vimspector.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'

" coding utils
" Plug 'editorconfig/editorconfig-vim'
Plug 'dense-analysis/ale'
Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree'
Plug 'AndrewRadev/splitjoin.vim' "gS gJ

" langs
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'neoclide/jsonc.vim'

" markdown
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'iamcco/mathjax-support-for-mkdp'

" debugger
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()

colorscheme gruvbox8
highlight Normal guibg=none

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

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

nnoremap <leader>M :MaximizerToggle!<CR>
" TODO think about vimspect mappings
" nnoremap <leader>dd :call vimspector#Launch()<CR>
" nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
" nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
" nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
" nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
" nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
" nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
" nnoremap <leader>de :call vimspector#Reset()<CR>
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
nnoremap <silent> <leader>i :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>sh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> <leader>ca :lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent> <leader>sd <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <leader>cf <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>cs <cmd>Telescope lsp_document_symbols<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

" powered by ThePrimeagen
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })<CR>

nnoremap <leader>f <cmd>lua require('telescope').extensions.fzf_writer.files()<CR>
nnoremap <leader>o <cmd>Telescope treesitter<CR>
nnoremap <leader>b <cmd>Telescope buffers<CR>
nnoremap <leader>a <cmd>Telescope live_grep<CR>
nnoremap <leader>pb <cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <leader>r <cmd>Telescope lsp_references<CR>
nnoremap <c-p> <cmd>Telescope git_files<CR>
nnoremap <leader>ws <cmd>lua require('telescope.builtin').lsp_workspace_symbols{query="*"}<CR>

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

noremap <Leader>pi :<c-u>PlugInstall<CR>
noremap <Leader>pu :<c-u>PlugUpdate<CR>
noremap <Leader>pc :<c-u>PlugClean<CR>


" echodoc
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
  autocmd FileType java call EnableEchoDoc()
augroup END
" echodo end

" clever-f
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
" end

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
let g:AutoPairsFlyMode = 1
" 禁止MapSpace
let g:AutoPairsMapSpace = 0
" auto-pairs end

" vim-bbye
noremap <leader><BS> :Bdelete<cr>
" vim-bbye end

" nerdtree
let g:NERDTreeQuitOnOpen=0
let g:NERDTreeMinimalUI=1
map <leader><tab> :<c-u>NERDTreeToggle<CR>
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
" nerdtreeend

" tagbar
nnoremap <silent> <leader>2 :TagbarToggle<CR>
let tags = "./tags"
let g:tagbar_autofocus = 0
let g:tagbar_sort = 0
"tagbar end

" vim-visual-multi
let g:VM_leader = '\\'
" vim-visual-multi end

" bufferline
set termguicolors
lua require'bufferline'.setup{ options={diagnostics = "nvim_lsp", sort_by="directory"} }
nnoremap <silent> gb :BufferLinePick<CR>

" overrite vim-vim-unimpaired ]b [b
nnoremap <silent>]b :BufferLineCycleNext<CR>
nnoremap <silent>[b :BufferLineCyclePrev<CR>
" bufferline end

" snip
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" markdown
let g:vim_markdown_math = 1
nmap <leader>md :MarkdownPreview<CR>
" markdown end

" vim-go: 关闭大部分功能
" 还是vim-go功能更完善，暂时lsp&vim-go 都启动吧
" lsp有diagnostic功能, 其他功能用vim-go
let g:go_gopls_enabled = 1
let g:go_addtags_transform = 'camelcase'
let g:go_auto_type_info = 0
let g:go_code_completion_enabled = 0
let g:go_def_mapping_enabled = 1
let g:go_doc_keywordprg_enabled = 0 "disabled, using K lsp hover()
let g:go_doc_popup_window = 0
let g:go_list_type = "quickfix"
let g:go_mod_fmt_autosave = 0
let g:go_textobj_enabled = 0
let g:go_metalinter_autosave_enabled = []
let g:go_metalinter_enabled = []
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_diagnostics_enabled = 0
" vim-go end

" ale
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
" let g:ale_linters = {
" \ 'python':[],
" \ 'java':[],
" \ 'go': [],
" \ 'markdown':[],
" \ 'rst':['rstcheck'],
" \ 'sh':['shellcheck'],
" \ }
let g:ale_linters = {
\ 'python': ['pylint', 'pyright'],
\ }
let g:ale_linters_explicit = 1
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'python': ['yapf', 'pyright'],
\ 'go': ['goimports'],
\ 'markdown':['remark-lint'],
\ 'sh':['shfmt'],
\ }
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 0
let g:ale_completion_enabled = 0
" nmap <silent> <space>j <Plug>(ale_next_wrap)
" nmap <silent> <space>k <Plug>(ale_previous_wrap)
" ale end

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
