" General
" =======

set nocompatible
set backspace=indent,eol,start
set backup		" keep a backup file
set history=1000 " keep 50 lines of command line history
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch     " highlight searches

"call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" Display
" =======

set nolazyredraw           " turn off lazy redraw
set background=dark        " black is the night
set number                 " line numbers
:highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA     " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling
set ruler
syntax on

" Statusline
" ==========

set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
set statusline+=%-40f\                    " path
set statusline+=%=%1*%y%*%*\              " file type
set statusline+=%10((%l,%c)%)\            " line and column
set statusline+=%P                        " percentage of file
set laststatus=2


" Text
" ====

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent smartindent cindent
set encoding=utf-8 fileencoding=utf-8
set textwidth=78
set mouse=va

" Backups/Swapfiles
" =================

set backup      " keep a backup file
set backupdir=~/.vim/backup/ " where to keep backup
set noswapfile " don't keep a swap file

" Highlight EOL whitespace
" ========================

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Plugins
" =======
"
" To init vundle and plugins run:
"  * git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"  * vim +BundleInstall +qall

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'Valloric/YouCompleteMe'



