syntax on
colo elflord

set number relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cursorline

set smartindent

set undofile

set hlsearch
set incsearch

set scrolloff=8

set updatetime=50

set colorcolumn=80

let mapleader = " "

nnoremap <leader>pv :Ex<CR>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

nnoremap <leader>p :call Print()<CR>

function! Print()
  let save_cursor = getpos('.')
  normal! "vyiw
  call setpos('.', save_cursor)
  execute 'normal! odprintf(1, "' . @v . ' -> %s\n", ' . @v . ');'
endfunction
