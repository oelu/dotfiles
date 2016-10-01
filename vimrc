filetype on

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'garbas/vim-snipmate.git'
Bundle 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-powerline'
Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-surround'
Plugin 'Shougo/neocomplete.vim'
Plugin 'klen/python-mode'
Plugin 'scrooloose/nerdcommenter'
Plugin 'python.vim'
Plugin 'python_match.vim'
Plugin 'pythoncomplete'
Plugin 'mbbill/undotree'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'racer-rust/vim-racer'
Plugin 'neovimhaskell/haskell-vim.git'
Plugin 'jiangmiao/auto-pairs.git'
Plugin 'ervandew/supertab.git'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'altercation/vim-colors-solarized'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" general vim options
syntax on
set number
set foldmethod=indent
set foldlevel=99
let mapleader = "," 
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround

" GUI options
set background=dark

if has('gui_running')
	set background=dark
	colorscheme solarized
else
	colorscheme solarized 
	set background=dark
endif

" Bash options
" " Start bash on F5
autocmd FileType sh map <F5> :w<CR>:!bash "%"<CR>


" Python options
let python_highlight_all=1
" Start python on F5
autocmd FileType python map <F5> :w<CR>:!/usr/local/bin/python2.7 -i "%"<CR>
" pymode options
let g:pymode_options = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'

" syntastic options
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['pylint', 'pep8', 'python', 'pyflakes']
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=3

" YouCompleteMe Options
let g:ycm_autoclose_preview_window_after_completion = 1

" SuperTab Options
let g:SuperTabClosePreviewOnPopupClose = 1

let g:neocomplcache_enable_at_startup = 1

" copy / yank problem inside tmux"
" http://stackoverflow.com/questions/11404800/fix-vim-tmux-yank-paste-on-unnamed-register
if $TMUX == ''
        set clipboard+=unnamed
endif


" powerline 
set laststatus=2
set encoding=utf-8 " Necessary to show Unicode glyphs
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors

" Rust Options
autocmd BufNewFile,BufRead *.rs set filetype=rust
" " Start cargo run on F5
autocmd FileType rs map <F5> :w<CR>:!cargo run "%"<CR>

" Remap fd for <ESC>
" Source: http://vim.wikia.com/wiki/Avoid_the_escape_key
imap fd <Esc>
