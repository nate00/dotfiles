set nocompatible          " Welcome to Vim.

" Colors
syntax enable
set background=dark

" Indentation
set cindent
set nosmartindent
set expandtab
set tabstop=2
set shiftwidth=2

" Make
set makeprg=g++\ %\ -O3\ -o\ t

" Autowrite
set autowrite

" Line numbers
set number

" Line wrapping
set nowrap                " Don't wrap long lines...
                          " ...but if I do, enable navigation within such lines.
map j gj
map k gk
set linebreak

" Backups
set backupdir=~/.vim/backup   " Backups in the working directory are annoying.
set directory=~/.vim/backup

" Persistent undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Searching
set ignorecase

" Status line
set laststatus=2          " Display filename.

" Highlight tabs
syn match tab display "\t"
hi link tab Error

" Folding
set foldmethod=syntax
set foldlevelstart=99

" Load my toy plugin
source ~/.vim/plugins/ConsolidatedMovement.vim

map <C-h> :call GoLeft()<CR>
map <C-j> :call GoDown()<CR>
map <C-k> :call GoUp()<CR>
map <C-l> :call GoRight()<CR>

" Disable annoying stuff from plugins
let g:vim_markdown_folding_disabled=1

" Open quickfix for grep, Ggrep
autocmd QuickFixCmdPost *grep* cwindow

""" Plugins """

" Set up Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Use Vundle to load plugins
Plugin 'tpope/vim-sensible'   " config defaults
Plugin 'tpope/vim-fugitive'   " git integration
Plugin 'kien/ctrlp.vim'       " fuzzy file finder

" Language-specific plugins
Plugin 'kchmck/vim-coffee-script'
Plugin 'digitaltoad/vim-jade'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'slim-template/vim-slim'

" Finish setting up Vundle
call vundle#end()
filetype plugin indent on
