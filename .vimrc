let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set number relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoread              
set backspace=2           
set hidden                
set ruler                 
set showmode              
set splitbelow            
set splitright            
set nobackup

set smartindent

set hlsearch
set incsearch

set nobackup
set nowritebackup
set noswapfile
set undofile
let &undodir = expand("$HOME") . "/.vim/undodir"

set scrolloff=8

set updatetime=50

let mapleader = " "

nnoremap <leader>pv :Ex<CR>

nnorema>p <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

xnoremap <leader>p "_dP
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Plugins
call plug#begin()

Plug 'GlennLeo/cobalt2'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'MattesGroeger/vim-bookmarks'

call plug#end()

" cobalt2 
set termguicolors
colorscheme cobalt2

" fzf.vim
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fr :History/<CR>
nnoremap <leader>fp :Lines<CR>

" vim-bookmarks
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_auto_save = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_disable_ctrlp = 1

nmap <Leader>a <Plug>BookmarkToggle
nmap <Leader><Leader> <Plug>BookmarkShowAll
nmap <C-p> <Plug>BookmarkPrev
nmap <C-n> <Plug>BookmarkNext
