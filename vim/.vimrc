" Set up Vundle
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Use Vundle to load plugins
" TODO: why does vim-sensible eliminate the visual highlighting of visual mode?
"Plugin 'tpope/vim-sensible'   " config defaults
Plugin 'tpope/vim-fugitive'   " git integration
Plugin 'tpope/vim-tbone'      " tmux integration
Plugin 'tpope/vim-eunuch'     " for UNIX shell commands
Plugin 'tpope/vim-endwise'    " automatically insert 'end' after 'if', etc.
Plugin 'ctrlpvim/ctrlp.vim'         " fuzzy file finder
Plugin 'vim-scripts/matchit.zip'    " generalized %
Plugin 'dhruvasagar/vim-table-mode' " make nice ASCII tables
Plugin 'tpope/vim-speeddating'      " incr/decr complex types (required by vim-orgmode)
Plugin 'jceb/vim-orgmode'     " emulate emacs' orgmode
Plugin 'chrisbra/Colorizer'   " highlight hex colors
Plugin 'mileszs/ack.vim'      " use ack (or ag) to search
Plugin 'vim-scripts/SyntaxRange'  " dependency of vimdeck
Plugin 'tpope/vim-projectionist'  " I don't really understand this one yet, but it lets you classify files by path and then give them special functionality

" Language-specific plugins
Plugin 'kchmck/vim-coffee-script'
Plugin 'digitaltoad/vim-jade'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-bundler'
Plugin 'vim-ruby/vim-ruby'
Plugin 'slim-template/vim-slim'
Plugin 'derekwyatt/vim-scala'
Plugin 'git://vim-scripts/sql.vim--Stinson'
" Rendering the markdown somehow f's up my Vim session
"Plugin 'godlygeek/tabular'        " required by vim-markdown
"Plugin 'plasticboy/vim-markdown'
Plugin 'leafo/moonscript-vim'
"Plugin 'pearofducks/ansible-vim' " Something autoindents stupidly in YAML
"files. Maybe it's this plugin.
Plugin 'JamshedVesuna/vim-markdown-preview' " renders markdown in a browser
Plugin 'autowitch/hive.vim'
Plugin 'hallison/vim-rdoc'

" Finish setting up Vundle
call vundle#end()
filetype plugin indent on
set nocompatible          " Welcome to Vim.

" Sensible defaults
set backspace=indent,eol,start
set incsearch
set autoindent

" Colors
syntax enable
set background=dark

" Indentation
set expandtab             " Use soft tabs.
set shiftwidth=2          " Use two spaces for autoindent.
set tabstop=2             " Display hard tabs with width two.
set softtabstop=2         " Pressing tab inserts two spaces.

" Line numbers
set number
set ruler

" Line wrapping
set nowrap                " Don't wrap long lines...
                          " ...but if I do, enable navigation within such lines.
map j gj
map k gk

" Eager scrolling
set scrolloff=8
set sidescrolloff=15

" Backups
set backupdir=~/.vim/backup   " Backups in the working directory are annoying.
set directory=~/.vim/backup

" Persistent undo
set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" Status line
set laststatus=2          " Display filename.

" Highlight tabs
syntax match tab display "\t"
highlight link tab Error

" System clipboard
"set clipboard=unnamed

" Open quickfix for grep, Ggrep
autocmd QuickFixCmdPost *grep* cwindow

" %% is the directory of the current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" Wildignore
set wildignore+=*/tmp/cache/*

" Set leader keys
let mapleader=" "
let maplocalleader="-"

" Show the last line of the file, even if it's too long to fit
set display+=lastline

"""" Configure plasticboy/vim-markdown """"
let g:vim_markdown_folding_disabled = 1

"""" Configure JamshedVesuna/vim-markdown-preview """"
let vim_markdown_preview_github=1     " Use Github-flavored markdown
let vim_markdown_preview_browser='Google Chrome'
let vim_markdown_preview_hotkey='<C-m>'

""" Configure autowitch/hive.vim """
au BufNewFile,BufRead *.hql set filetype=hive expandtab
au BufNewFile,BufRead *.hql.erb set filetype=hive expandtab

""" Configure ctrlpvim/ctrlp.vim """
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_max = 250
" I'd love to use MRU mode, but it doesn't search files I haven't opened
" recently.
"let g:ctrlp_cmd = 'CtrlPMRU'    " Use MRU mode
if executable("ag")
  " Use ag to take advantage of .agignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

""" Configure dhruvasagar/vim-table-mode """
" These settings create tables compatible with Github-flavored Markdown
let g:table_mode_corner = '|'
let g:table_mode_separator = '|'
let g:table_mode_fillchar = '-'


""" Security """
" Avoid this ACE vulnerability:
" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
set modelines=0
set nomodeline


""" Clipboard """

" Set up pbcopy yanking

nnoremap <silent> <leader>y :set operatorfunc=<SID>PbcopyOperator<CR>g@
vnoremap <silent> <leader>y :<C-U>call <SID>PbcopyOperator(visualmode())<CR>

function! s:PbcopyOperator(text_object_type)
  let saved_unnamed_register = @@

  if a:text_object_type ==# 'v'
    silent execute "normal! `<v`>y"
  elseif a:text_object_type ==# 'V'
    silent execute "normal! `<V`>y"
  elseif a:text_object_type ==# 'char'
    silent execute "normal! `[v`]y"
  elseif a:text_object_type ==# 'line'
    silent execute "normal! `[V`]y"
  else
    return
  endif

  call PbcopyText(@@)

  let @@ = saved_unnamed_register
endfunction

function! PbcopyRange() range
  let text = join(getline(a:firstline, a:lastline), "\n")

  call PbcopyText(text)
endfunction

function! PbcopyText(text)
  let escaped_text = shellescape(a:text)

  " Remove the unwanted backslashes that shellescape inserts before newlines.
  " I think this shellescape behavior was removed in newer versions of Vim
  " (see https://github.com/vim/vim/issues/1590), so check for the behavior
  " before trying to correct it.
  let vim_inserts_backslashes_before_newlines = shellescape("\n") ==# "'\\\n'"
  if vim_inserts_backslashes_before_newlines
    let escaped_text = substitute(escaped_text, "\\\\\n", "\n", "g")
  endif

  echo system('echo ' . escaped_text . ' | pbcopy')
endfunction





""" Configure mileszs/ack.vim """
" Use ag over ack
let g:ackprg = "ag --vimgrep"

nnoremap <leader>a :set operatorfunc=<SID>AckOperator<cr>g@
vnoremap <leader>a :<c-u>call <SID>AckOperator(visualmode())<cr>

" TODO: this doesn't work when the query is process_next_batch!
" presumably because of the exclamation point
function! s:AckOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    execute "normal! `<v`>y"
  elseif a:type ==# 'char'
    execute "normal! `[v`]y"
  else
    return
  endif

  silent execute "LAck! " . shellescape('\b' . @@ . '\b')

  let @@ = saved_unnamed_register
endfunction


""" Configure vim-speeddating """
" In ~/.vim/after/plugin/speeddating.vim


" Timestamps
nnoremap <leader>s i<C-R>=strftime("%Y-%m-%d %a")<CR><Esc>

