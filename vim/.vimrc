" ~/.vimrc - Vim configuration (fallback for environments without nvim)

set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8
set background=dark

let mapleader = " "
let maplocalleader = " "

" Filetype plugins handle per-language indent.
" Settings below are the fallback for filetypes without their own ftplugin.
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent

set number
set relativenumber
if exists('+signcolumn') | set signcolumn=yes | endif
set cursorline
set scrolloff=8
set sidescrolloff=8
set nowrap
if has('termguicolors') | set termguicolors | endif

set ignorecase
set smartcase
set incsearch
set hlsearch

set splitright
set splitbelow

set undofile
set undodir=~/.vim/undo//
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif
set noswapfile
set nobackup
set updatetime=250
set timeoutlen=400
set ttimeoutlen=10

set mouse=
set hidden
set backspace=indent,eol,start
set wildmenu

set list
set listchars=trail:·,nbsp:␣

" Keymaps
" <C-l> here, where the nvim config uses <Esc>. Terminfo sends Up as ESC O A,
" so mapping <Esc> in normal mode makes vim take the mapping and then read the
" O as "open a line above and insert" -- arrow keys corrupt the buffer, and not
" only over a slow link. Neovim parses the sequence properly and is unaffected.
" <C-l> redraws as well, which is its traditional job.
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
vnoremap < <gv
vnoremap > >gv

" Jump to last cursor position when reopening a file
augroup last_cursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"' | endif
augroup END
