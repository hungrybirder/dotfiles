set nocompatible

let mapleader = ' '

nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" general setting
source $HOME/.config/nvim/general.vim

" load plugins
source $HOME/.config/nvim/plugins.vim

" source $HOME/cs/dotfiles/nvim/colors.vim

for f in split(glob('~/.config/nvim/plugins.d/*.vim'), '\n')
	exe 'source' f
endfor

let s:load_dir = expand('<sfile>:p:h')
exec printf('luafile %s/lua/init.lua', s:load_dir)
