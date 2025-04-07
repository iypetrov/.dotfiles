scriptencoding utf-8
set encoding=utf-8

" Basic
let mapleader=" "         " The <leader> key
set autoread              " Reload files that have not been modified
set backspace=2           " Makes backspace behave like you'd expect
set colorcolumn=80        " Highlight 80 character limit
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

" Make splits
nnoremap <leader>s :split<CR>
nnoremap <leader>v :vsplit<CR>

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

" Shortcut for pasting from without changing the vim buffer
nnoremap <leader>p "_dP
vnoremap <leader>p "_dP

" Shortcut for deleting from without changing the vim buffer
vnoremap <leader>d "_d

" Go back to the file tree
nnoremap <leader>pv :Ex<CR>

" Replace currrent word occurrences
nnoremap <leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Get rid of search highlights
noremap <silent><leader>/ :nohlsearch<cr>

" Command to write as root if we dont' have permission
cmap w!! %!sudo tee > /dev/null %

" Buffer management
nnoremap <leader>d   :bd<cr>

" Clear whitespace at the end of lines automatically
" autocmd BufWritePre * :%s/\s\+$//e

" Don't fold anything.
autocmd BufWinEnter * set foldlevel=999999

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

Plug 'nlknguyen/papercolor-theme'
Plug 'JaySandhu/xcode-vim'
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

call plug#end()

set termguicolors
set background=light
" colorscheme papercolor
colorscheme xcode

" fzf
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.3, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_vim_relative_paths = 1

nnoremap <leader>ff :call fzf#run(fzf#wrap({
    \ 'source': 'find . -type d \( -name .git -o -name node_modules -o -name vendor -o -name tmp -o -name .terraform \) -prune -o -type f -print',
    \ 'sink': { file -> execute('e ' . file) },
    \ 'options': '--preview="bat --color=always --style=numbers {}" --preview-window=40%'
\ }))<CR>

nnoremap <leader>fp :RG<CR>

" noremap <leader>fp :call fzf#run(fzf#wrap({
"     \ 'source': 'rg --vimgrep ""',
"     \ 'sink': { line -> execute('e ' . split(line, ':')[0] . ' \| ' . split(line, ':')[1]) },
"     \ 'options': '--bind "change:reload:rg --vimgrep {q}" ' .
"     \            '--delimiter : --nth 4 ' .
"     \            '--preview="~/scripts/fzf-keyword-preview.sh {1} {2}" --preview-window=40%'
" \ }))<CR>

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
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_align = 'after'

highlight LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
highlight LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
highlight LspDiagnosticsVirtualTextInformation guifg=Blue ctermfg=Blue
highlight LspDiagnosticsVirtualTextHint guifg=Green ctermfg=Green

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

" terraform
function! OpenURL(url)
  if a:url != ''
    let l:command = '!open ' . shellescape(a:url) . ' > /dev/null 2>&1 &'
    execute l:command
  endif
endfunction

function! ConvertProviderToFull(provider_short) abort
    let providers = {
        \ 'hcp': 'hashicorp/hcp',
        \ 'aws': 'hashicorp/aws',
        \ 'awscc': 'hashicorp/awscc',
        \ 'vaultt': 'hashicorp/vault',
        \ 'cloudflare': 'cloudflare/cloudflare',
        \ 'github': 'integrations/github',
    \ }
    return get(providers, a:provider_short, '')
endfunction

function! TerraformDocBrowser()
    let l:line = getline('.')

    let l:block_pattern = '^\s*\(resource\|data\)\s\+"\([^"]\+\)"\s\+"\([^"]\+\)"'
    let l:field_pattern = '^\s*\w\+\s*='
    let l:field_block_pattern = '^\s*\(\w\+\)\s*{'

    if l:line =~ l:block_pattern
        let l:block = matchstr(l:line, '^\s*\(resource\|data\)')
        if l:block == 'resource'
            let l:block_type = 'resources'
        elseif l:block == 'data'
            let l:block_type = 'data-sources'
        endif

        let l:resource_name = substitute(matchstr(l:line, l:block_pattern), '^\s*\(resource\|data\)\s\+"\([^"]\+\)"\s\+"\([^"]\+\)"', '\2', '')
        let l:provider_short = matchstr(l:resource_name, '^[^_]\+')
        let l:provider = ConvertProviderToFull(l:provider_short)
        let l:target = matchstr(l:resource_name, '_\zs.*')
        let l:url = 'https://registry.terraform.io/providers/' . l:provider . '/latest/docs/' . l:block_type . '/' . l:target
        call OpenURL(l:url)
    elseif l:line =~ l:field_pattern || l:line =~ l:field_block_pattern
        if l:line =~ l:field_pattern
            let l:field = matchstr(l:line, '^\s*\zs\w\+\ze\s*=')
        else
            let l:field = matchstr(l:line, '^\s*\zs\w\+\ze\s*{')
        endif

        let l:block_line_num = search(l:block_pattern, 'bnW')
        let l:field_block_line_num = search(l:field_block_pattern, 'bnW')
        if l:block_line_num > 0
            let l:block_line = getline(l:block_line_num)
            let l:block = matchstr(l:block_line, '^\s*\(resource\|data\)')
            if l:block == 'resource'
                let l:block_type = 'resources'
            elseif l:block == 'data'
                let l:block_type = 'data-sources'
            endif

            let l:resource_name = substitute(matchstr(l:block_line, l:block_pattern), '^\s*\(resource\|data\)\s\+"\([^"]\+\)"\s\+"\([^"]\+\)"', '\2', '')
            let l:provider_short = matchstr(l:resource_name, '^[^_]\+')
            let l:provider = ConvertProviderToFull(l:provider_short)
            let l:target = matchstr(l:resource_name, '_\zs.*')

            if l:line =~ l:field_pattern 
                let l:url = 'https://registry.terraform.io/providers/' . l:provider . '/latest/docs/' . l:block_type . '/' . l:target . '\#'. l:field . '-1'
            elseif l:line =~ l:field_block_pattern
                let l:url = 'https://registry.terraform.io/providers/' . l:provider . '/latest/docs/' . l:block_type . '/' . l:target . '\#'. l:field
            endif
            call OpenURL(l:url)
        endif
    endif
endfunction

augroup terraform_mappings
  autocmd!
  autocmd FileType terraform nnoremap <leader>dc :call TerraformDocBrowser()<CR><CR>
augroup END
