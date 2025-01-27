scriptencoding utf-8
set encoding=utf-8

" Basic
let mapleader=" "         " The <leader> key
set autoread              " Reload files that have not been modified
set backspace=2           " Makes backspace behave like you'd expect
" set colorcolumn=80        " Highlight 80 character limit
set tabstop=4             " Make tab spacing
set softtabstop=4
set shiftwidth=4
set expandtab
set hidden                " Allow buffers to be backgrounded without being saved
set number relativenumber " Show the liner numbes in realtive mode
set ruler                 " Show the line number and column in the status bar
set scrolloff=999         " Keep the cursor int the center of the screen
set showmatch             " Highlight matching braces
set showmode              " Show the current mode on the open buffer
set splitbelow            " Splits show up below by default
set splitright            " Splits go to the right by default
set title                 " Set the title for gvim
set visualbell            " Use a visual bell to notify us
set nowrap                " If the line is too long don't split it on the new line

" Customize session options. Namely, I don't want to save hidden and
" unloaded buffers or empty windows.
set sessionoptions="curdir,folds,help,options,tabpages,winsize"

syntax on                 " Enable filetype detection by syntax

" Backup settings
set nobackup
set nowritebackup
set noswapfile
set undofile
let &undodir = expand("$HOME") . "/.vim/undodir"

" Search settings
set hlsearch   " Highlight results
set ignorecase " Ignore casing of searches
set incsearch  " Start showing results as you type
set smartcase  " Be smart about case sensitivity when searching

" Tab settings
set expandtab     " Expand tabs to the proper type and size
set tabstop=4     " Tabs width in spaces
set softtabstop=4 " Soft tab width in spaces
set shiftwidth=4  " Amount of spaces when shifting

" Tab completion settings
set wildmode=list:longest     " Wildcard matches show a list, matching the longest first
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.6           " Ignore Go compiled files
set wildignore+=*.pyc         " Ignore Python compiled files
set wildignore+=*.rbc         " Ignore Rubinius compiled files
set wildignore+=*.swp         " Ignore vim backups

" Make navigation up and down a lot more pleasent
map j gj
map k gk

" Make navigating around splits easier
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Shortcut to yanking to the system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
vnoremap <leader>Y "+Y

" Go back to the file tree
nnoremap <leader>pv :Ex<CR>

" Replace currrent word occurrences
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Get rid of search highlights
noremap <silent><leader>/ :nohlsearch<cr>

" Command to write as root if we dont' have permission
cmap w!! %!sudo tee > /dev/null %

" Buffer management
nnoremap <leader>d   :bd<cr>

" Clear whitespace at the end of lines automatically
autocmd BufWritePre * :%s/\s\+$//e

" Don't fold anything.
autocmd BufWinEnter * set foldlevel=999999

" Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'lisposter/vim-blackboard'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'airblade/vim-gitgutter'
Plug 'mbbill/undotree'
Plug 'github/copilot.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'elixir-editors/vim-elixir'

call plug#end()

" blackboard
set termguicolors
set background=dark
colorscheme blackboard

" fzf.vim
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>fp :Rg<CR>

" nerdtree
let NERDTreeShowHidden=1
let g:NERDTreeHijackNetrw=0
nnoremap <C-t> :NERDTreeToggle<CR>

" vim-bookmarks
let g:bookmark_sign = '>>'
let g:bookmark_save_per_working_dir = 1
let g:bookmark_manage_per_buffer = 1
let g:bookmark_auto_close = 1
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_auto_save = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_disable_ctrlp = 1

nmap <leader>a <Plug>BookmarkToggle
nmap <leader><leader> <Plug>BookmarkShowAll
nmap <C-p> <Plug>BookmarkPrev
nmap <C-n> <Plug>BookmarkNext

" vim-gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" undotree
nmap <leader>h :UndotreeToggle<CR>

" vim-lsp
nmap <leader>[[ :LspPreviousError<CR>
nmap <leader>]] :LspNextError<CR>

augroup LspCloseReferenceWindow
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
augroup END

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-b> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" vim-go
let g:go_def_mapping_enabled = 0
let g:go_fmt_command = "goimports"

augroup go_mappings
  autocmd!
  autocmd FileType go nmap <leader>err :GoIfErr<CR>
  autocmd FileType go nmap <leader>dc :GoDocBrowser<CR>
augroup END

