syntax on
filetype plugin indent on

set exrc
set guicursor=
set number relativenumber
set hlsearch
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
set undodir=~/codes/dotfiles/nvim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set signcolumn=yes

" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set colorcolumn=80

set clipboard& clipboard+=unnamed

set grepprg=rg

vnoremap < <gv
vnoremap > >gv

" Navigating in Command Mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

call plug#begin('~/codes/dotfiles/nvim/plugged')

" Neovim lsp Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tjdevries/nlua.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'Shougo/echodoc.vim'


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
Plug 'gruvbox-community/gruvbox'

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

" supertab is good for lsp + ultisnip
Plug 'ervandew/supertab'

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

colorscheme gruvbox


if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1
let mapleader = " "
" nmap <silent> <leader>ev :e $MYVIMRC<CR>
" nmap <silent> <leader>sv :so $MYVIMRC<CR>

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_branch_actions = {
      \ 'rebase': {
      \   'prompt': 'Rebase> ',
      \   'execute': 'echo system("{git} rebase {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-r',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}


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
nnoremap <c-h> :wincmd h<CR>
nnoremap <c-j> :wincmd j<CR>
nnoremap <c-k> :wincmd k<CR>
nnoremap <c-l> :wincmd l<CR>
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

" let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_ignore_case = 1

lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.clangd.setup{ on_attach=require'completion'.on_attach, cmd={"/usr/local/opt/llvm/bin/clangd", "--background-index"} }
lua require'lspconfig'.pyls.setup{ on_attach=require'completion'.on_attach }
" lua require'lspconfig'.gopls.setup{ on_attach=require'completion'.on_attach }
lua <<EOF
  require "lspconfig".gopls.setup {
    on_attach=require'completion'.on_attach,
    cmd = {"gopls", "--remote=auto"},
  }
EOF

lua require'lspconfig'.rust_analyzer.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.bashls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.jsonls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.yamlls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.html.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.cmake.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.dockerls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.sumneko_lua.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.sqlls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.vuels.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.vimls.setup{ on_attach=require'completion'.on_attach }

lua <<EOF
require'lspconfig'.diagnosticls.setup{
  filetypes = { "sh" },
}
EOF

lua<<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  },

  -- nvim-treesitter/nvim-treesitter-textobjects
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}
EOF

lua <<EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    mappings = {
      i = {
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
    },
    preview_cutoff = 20,
  },
  extensions = {
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      },
      fzf_writer = {
          use_highlighter = true,
      },
  }
}
require('telescope').load_extension('fzy_native')
EOF

nnoremap <silent> <leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>i :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>sh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>sd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" nnoremap <leader>f :lua require('telescope').extensions.fzf_writer.files()<CR>
nnoremap <leader>f :Telescope find_files<CR>
nnoremap <leader>o :Telescope lsp_document_symbols<CR>
nnoremap <leader>r :Telescope lsp_references<CR>
nnoremap <c-p> :Telescope git_files<CR>
nnoremap <leader>sv :so ~/codes/dotfiles/nvim/init.vim<CR>
nnoremap <leader>ev :edit ~/codes/dotfiles/nvim/init.vim<CR>
" nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
" nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
" nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>

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

let g:neoformat_enabled_python = ['yapf']
let g:neoformat_enabled_go = ['goimports']
let g:neoformat_enabled_ruby = ['']
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" Use <Tab> and <S-Tab> to navigate through popup menu
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:UltiSnipsExpandTrigger="<tab>"
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
