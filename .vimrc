" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

syntax on
set number
filetype plugin on
execute pathogen#infect()
syntax on
filetype plugin indent on

"let g:ycm_global_ycm_extra_conf= '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"let g:clang_use_library = 1
"let g:clang_user_options='|| exit 0'

set nocp

set incsearch
set ignorecase
set cursorline
set ruler

syntax enable
set t_Co=256
set background=dark
"let g:molokai_original=1
"let g:solarized_termcolors=256
"let g:rehash256=1
colorscheme desert

"support chinese
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

let g:SuperTabRetainCompletionType=2 

map <C-h> <C-w>h 
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
au BufRead *.py map <buffer> <F2> :w<CR>:!/root/localpython3/bin/python3 % <CR>
au BufRead *.py map <buffer> <F3> :w<CR>:!/root/localpython3/bin/pyflakes % <CR>

function InsertPythonComment()
    exe 'normal'.1.'G'
    let line = getline('.')
    if line =~ '^#!.*$' || line =~ '^#.*coding:.*$'
        return
    endif
    normal O
    call setline('.', '#!/usr/bin/env python3.5')
    normal o
    call setline('.', '# -*- coding:utf-8 -*-')
    normal o
    call setline('.', '#')
    normal o
    call setline('.', '#   Author  :   '.g:python_author)
    normal o
    call setline('.', '#   E-mail  :   '.g:python_email)
    normal o
    call setline('.', '#   Date    :   '.strftime("%y/%m/%d %H:%M:%S"))
    normal o
    call setline('.', '#   Desc    :   ')
    normal o
    call setline('.', '#')
    normal o
    call cursor(7, 17)
endfunction
function InsertCommentWhenOpen()
    if a:lastline == 1 && !getline('.')
        call InsertPythonComment()
    end
endfunc
au FileType python :%call InsertCommentWhenOpen()
au FileType python map <F4> :call InsertPythonComment()<cr>

let g:python_author = 'yaoxiang'       
let g:python_email  = '952059083@qq.com'   

"Syntastic setting
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>'
let g:syntastic_enable_highlighting=1
let g:syntastic_python_python_exec = '/root/localpython3/bin/python3.5'
let g:syntastic_python_checkers = [ 'pyflakes' ]
let g:syntastic_python_pyflakes_args = '--ignore="E501,E302,E261,E701,E241,E126,E127,E128,W801"'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"let g:syntastic_enable_perl_checker = 1

let g:airline_powerline_fonts=1
set laststatus=2

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview


"let g:pymode_rope_goto_definition_bind = "<C-]>"
"let g:pymode_run_bind = "<C-S-e>"
"let g:pymode_doc_bind = "<C-S-d>"
"let g:pymodepython = 'python3'

"setting for ctrlp
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*

"setting for jedi-vim
let g:jedi#usages_command = "<leader>z"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0

"setting for python_editing
set nofoldenable

"setting for pydiction
let g:pydiction_location='/root/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height = 3

execute pathogen#infect()

autocmd FileType python set omnifunc=pythoncomplete#Complete
