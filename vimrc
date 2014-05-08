" Pathogen
" autoload pathogen
execute pathogen#infect()
call pathogen#helptags()
syntax on
" Plugins can be installed under .vim/bundle
" Now any plugins you wish to install can be extracted to a subdirectory under
" ~/.vim/bundle, and they will be added to the 'runtimepath'. Observe:
"
" cd ~/.vim/bundle
" git clone git://github.com/tpope/vim-sensible.git

filetype plugin indent on     " required

" AUTOSTART COMMANDS"
" Start python on F5
autocmd FileType python map <F5> :w<CR>:!python "%"<CR>
" Start bash on F5
autocmd FileType sh map <F5> :w<CR>:!bash "%"<CR>
autocmd FileType ruby map <F5> :w<CR>:!ruby "%"<CR>
" enable syntax higlighting

" normal line numbers"
set number

" tab options for python
set tabstop=4
set shiftwidth=4
set expandtab

" plugin options
"" ctrl+p
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"" pymode options
""" default options
let g:pymode_options = 1
""" doc
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'

" tab switching keymaps
map  <C-l> :tabn<CR>
map  <C-h> :tabp<CR>
map  <C-n> :tabnew<CR>


" neosnippet options
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
"
" " SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
"
" " For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
