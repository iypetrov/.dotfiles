scriptencoding utf-8
set encoding=utf-8

" Basic
let mapleader=" "         " The <leader> key
set autoread              " Reload files that have not been modified
set backspace=2           " Makes backspace behave like you'd expect
" set colorcolumn=80        " Highlight 80 character limit
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

" Telescope
let g:recent_files = copy(v:oldfiles)

function! AddToRecentFiles(file)
  let file = expand(a:file)
  call filter(g:recent_files, 'v:val !=# file')
  call insert(g:recent_files, file)
  if len(g:recent_files) > 100
    let g:recent_files = g:recent_files[:99]
  endif
endfunction

autocmd BufRead * call AddToRecentFiles(expand('<afile>:p'))

function! FzfGitAllFiles()
  let git_root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in a Git repository'
    return
  endif

  let git_files_relative = split(system('git ls-files'), '\n')

  if empty(git_files_relative)
    echo 'No files in the current Git project'
    return
  endif

  call fzf#run(fzf#wrap({
        \ 'source': git_files_relative,
        \ 'sink': { file -> execute('e ' . git_root . '/' . file) },
        \ 'options': '--prompt="> " --preview="bat --style=numbers --color=always --line-range :500 ' . git_root . '/{}"'
        \ }))
endfunction

function! FzfGitRecentFiles()
  let git_root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in a Git repository'
    return
  endif

  let git_files_relative = split(system('git ls-files'), '\n')

  let git_files = map(git_files_relative, { _, file -> resolve(git_root . '/' . file) })

  let recent_files = map(copy(g:recent_files), { _, file -> expand(file) })
  let recent_git_files = filter(recent_files, { _, file -> index(git_files, file) >= 0 })

  let recent_git_files_relative = map(recent_git_files, { _, file -> substitute(file, git_root . '/', '', '') })

  if empty(recent_git_files_relative)
    echo 'No recently visited files in the current Git project'
    return
  endif

  call fzf#run(fzf#wrap({
        \ 'source': recent_git_files_relative,
        \ 'sink': { file -> execute('e ' . git_root . '/' . file) },
        \ 'options': '--prompt="> " --preview="bat --style=numbers --color=always --line-range :500 ' . git_root . '/{}"'
        \ }))
endfunction

function! FzfRgFiles(query)
  let git_root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in a Git repository'
    return
  endif

  let git_files_relative = split(system('git ls-files'), '\n')

  let rg_command = 'rg --column --line-number --no-heading --color=never --smart-case -e ' . shellescape(a:query) . ' '

  let file_filter = join(map(copy(git_files_relative), { _, file -> shellescape(file) }), ' ')
  let rg_command .= ' ' . file_filter

  let rg_command .= ' | awk -v root="' . git_root . '/" ''{ sub(root, ""); print }'''

  call fzf#vim#grep(rg_command, 1, fzf#vim#with_preview({'options': ['--nth=3..']}), 0)
endfunction

nnoremap <leader>ff :call FzfGitAllFiles()<CR>
nnoremap <leader>fr :call FzfGitRecentFiles()<CR>
nnoremap <Leader>fp :call FzfRgFiles("")<CR>

" Harpoon
let g:custom_tags = []

function! ToggleCustomTag()
    let file_path = expand('%:p')
    let line_num = line('.')
    let line_text = getline('.')

    " Check if the tag already exists
    let index_to_remove = -1
    for i in range(len(g:custom_tags))
        if g:custom_tags[i].file == file_path && g:custom_tags[i].line == line_num
            let index_to_remove = i
            break
        endif
    endfor

    if index_to_remove != -1
        " If the tag exists, remove it
        call remove(g:custom_tags, index_to_remove)
        echo "Removed tag at line " . line_num
    else
        " If the tag doesn't exist, add it
        call add(g:custom_tags, {
            \ 'file': file_path,
            \ 'line': line_num,
            \ 'text': line_text
        \ })
        echo "Added tag at line " . line_num
    endif
endfunction

function! JumpToPreviousTag()
    if len(g:custom_tags) == 0
        echo "No tags found."
        return
    endif

    let current_index = -1
    for i in range(len(g:custom_tags))
        if g:custom_tags[i].file == expand('%:p') && g:custom_tags[i].line == line('.')
            let current_index = i
            break
        endif
    endfor

    if current_index == -1
        let current_index = len(g:custom_tags)
    endif

    let prev_index = (current_index - 1) % len(g:custom_tags)
    let prev_tag = g:custom_tags[prev_index]

    execute 'edit ' . prev_tag.file
    execute prev_tag.line
endfunction

function! JumpToNextTag()
    if len(g:custom_tags) == 0
        echo "No tags found."
        return
    endif

    let current_index = -1
    for i in range(len(g:custom_tags))
        if g:custom_tags[i].file == expand('%:p') && g:custom_tags[i].line == line('.')
            let current_index = i
            break
        endif
    endfor

    if current_index == -1
        let current_index = -1
    endif

    let next_index = (current_index + 1) % len(g:custom_tags)
    let next_tag = g:custom_tags[next_index]

    execute 'edit ' . next_tag.file
    execute next_tag.line
endfunction

function! ShowAllTags()
    if len(g:custom_tags) == 0
        echo "No tags found."
        return
    endif

    let qf_list = []
    for tag in g:custom_tags
        call add(qf_list, {
            \ 'filename': tag.file,
            \ 'lnum': tag.line,
            \ 'text': tag.text
        \ })
    endfor

    call setqflist(qf_list)
    copen

    " Map dd to delete the current entry from the quickfix list and g:custom_tags
    nnoremap <buffer> dd :call DeleteFromQuickfix()<CR>
endfunction

function! DeleteFromQuickfix()
    let current_line = line('.') - 1 " Quickfix list is 1-indexed
    if current_line >= 0 && current_line < len(g:custom_tags)
        call remove(g:custom_tags, current_line)
        call setqflist([])
        call ShowAllTags()
    endif
endfunction

nnoremap <leader>a :call ToggleCustomTag()<CR>
nnoremap <C-p> :call JumpToPreviousTag()<CR>
nnoremap <C-n> :call JumpToNextTag()<CR>
nnoremap <leader><leader> :call ShowAllTags()<CR>

" Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'aperezdc/vim-elrond'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'preservim/nerdtree'
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

" elrond
set termguicolors
set background=dark
colorscheme elrond

" nerdtree
let NERDTreeShowHidden=1
let g:NERDTreeHijackNetrw=0
nnoremap <C-t> :NERDTreeToggle<CR>

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

