set nocompatible
syntax enable
set background=dark
set cindent
set nowrap
set tabstop=2
set shiftwidth=2
set makeprg=g++\ %\ -O3\ -o\ t
set autowrite
set linebreak
set nolist
set ruler
set number
set nosmartindent
set expandtab
set smarttab

map j gj
map k gk

" put backups out of the way
set backupdir=~/.vim/backup
set directory=~/.vim/backup
" persistent undo
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Ignore case for searches
set ignorecase

" Display filename at all times
set ls=2

" Make <Esc> then O work faster. Also disable arrow keys in insert mode.
"set noesckeys
" Make <Esc> then O work faster.
set timeout timeoutlen=1000 ttimeoutlen=100

" Use tags from all directories
set tags=tags;/

" Highlight tabs
syn match tab display "\t"
hi link tab Error

set foldmethod=syntax
set foldlevelstart=99

" Wrong way to do this, I think
source ~/.vim/plugins/ConsolidatedMovement.vim

map <C-h> :call GoLeft()<CR>
map <C-j> :call GoDown()<CR>
map <C-k> :call GoUp()<CR>
map <C-l> :call GoRight()<CR>

" Disable annoying stuff from plugins
let g:vim_markdown_folding_disabled=1

" Open quickfix for grep, Ggrep
autocmd QuickFixCmdPost *grep* cwindow

set wildmenu
set wildmode=full

" User :NumbersToggle or :NumbersOnOff to switch line numbering
"
" Notes on shortcuts:
" :vert stag {class-name}   " opens the file containing class {class-name} in a 
"                           " vertical split
" :tab tag {class-name}     " opens the file containing class {class-name} in
"                           " a new tab

