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
" Persistent custom marks stored in ~/.vim-marks by default
let s:marks_file = expand('$HOME') . '/.vim-marks'

" Load marks from file on startup
function! LoadCustomTags() abort
  if !filereadable(s:marks_file)
    let g:custom_tags = []
    return
  endif
  let lines = readfile(s:marks_file)
  let g:custom_tags = []
  for l in lines
    let parts = split(l, '\t')
    if len(parts) >= 3
      let file = parts[0]
      let lnum = str2nr(parts[1])
      let text = parts[2]
      call add(g:custom_tags, {'file': file, 'line': lnum, 'text': text})
    endif
  endfor
endfunction

" Save marks to file whenever g:custom_tags changes
function! SaveCustomTags() abort
  let lines = []
  for tag in g:custom_tags
    call add(lines, tag.file . "\t" . tag.line . "\t" . substitute(tag.text, '\t', '    ', 'g'))
  endfor
  call writefile(lines, s:marks_file)
endfunction

" Initialize storage and load existing marks
if !exists('g:custom_tags')
  let g:custom_tags = []
endif
autocmd VimEnter * call LoadCustomTags()

" Toggle a mark at the current file and line
function! ToggleCustomTag() abort
  let file_path = expand('%:p')
  let line_num = line('.')
  let line_text = getline('.')
  let idx = -1
  for i in range(len(g:custom_tags))
    if g:custom_tags[i].file == file_path && g:custom_tags[i].line == line_num
      let idx = i
      break
    endif
  endfor
  if idx != -1
    call remove(g:custom_tags, idx)
    echo 'Removed tag at ' . file_path . ':' . line_num
  else
    call add(g:custom_tags, {'file': file_path, 'line': line_num, 'text': line_text})
    echo 'Added tag at ' . file_path . ':' . line_num
  endif
  call SaveCustomTags()
endfunction

" Jump to previous stored mark
function! JumpToPreviousTag() abort
  if empty(g:custom_tags)
    echo 'No tags found.'
    return
  endif
  let cur = expand('%:p') . ':' . line('.')
  let idx = -1
  for i in range(len(g:custom_tags))
    if g:custom_tags[i].file . ':' . g:custom_tags[i].line == cur
      let idx = i
      break
    endif
  endfor
  if idx == -1
    let idx = len(g:custom_tags)
  endif
  let prev = (idx - 1 + len(g:custom_tags)) % len(g:custom_tags)
  execute 'edit ' . g:custom_tags[prev].file
  call cursor(g:custom_tags[prev].line, 1)
endfunction

" Jump to next stored mark
function! JumpToNextTag() abort
  if empty(g:custom_tags)
    echo 'No tags found.'
    return
  endif
  let cur = expand('%:p') . ':' . line('.')
  let idx = -1
  for i in range(len(g:custom_tags))
    if g:custom_tags[i].file . ':' . g:custom_tags[i].line == cur
      let idx = i
      break
    endif
  endfor
  let next = (idx + 1) % len(g:custom_tags)
  execute 'edit ' . g:custom_tags[next].file
  call cursor(g:custom_tags[next].line, 1)
endfunction

" Show all tags in quickfix
function! ShowAllTags() abort
  if empty(g:custom_tags)
    echo 'No tags found.'
    return
  endif
  let qf = []
  for tag in g:custom_tags
    call add(qf, {'filename': tag.file, 'lnum': tag.line, 'text': tag.text})
  endfor
  call setqflist(qf)
  copen
  nnoremap <buffer> dd :call DeleteFromQuickfix()<CR>
endfunction

" Delete mark from quickfix and save
function! DeleteFromQuickfix() abort
  let idx = line('.') - 1
  if idx >= 0 && idx < len(g:custom_tags)
    call remove(g:custom_tags, idx)
    call SaveCustomTags()
    call setqflist([])
    call ShowAllTags()
  endif
endfunction

" Key mappings
nnoremap <leader>a :call ToggleCustomTag()<CR>
nnoremap <C-p>   :call JumpToPreviousTag()<CR>
nnoremap <C-n>   :call JumpToNextTag()<CR>
nnoremap <leader><leader> :call ShowAllTags()<CR>

" Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'JaySandhu/xcode-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'mbbill/undotree'
Plug 'github/copilot.vim'
Plug 'APZelos/blamer.nvim'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

set termguicolors
set background=light
colorscheme xcode

" fzf
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.3, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_vim_relative_paths = 1

nnoremap <leader>ff :call fzf#run(fzf#wrap({
    \ 'source': 'find . -type d \( -name .git -o -name node_modules -o -name dist -o -name target -o -name vendor -o -name tmp -o -name .terraform \) -prune -o -type f -print',
    \ 'sink': { file -> execute('e ' . file) },
    \ 'options': '--preview="batcat --color=always --style=numbers {}" --preview-window=40%'
\ }))<CR>
nnoremap <leader>fp :RG<CR>

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

" blamer
let g:blamer_enabled = 0
let g:blamer_template = '<committer>, <committer-time> • <summary>, <commit-long>'

" vim-lsp
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_align = 'after'
let g:lsp_settings = {
\  'go': {
\    'cmd': ['gopls'],
\    'allowlist': ['go'],
\  },
\}

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
let g:go_play_browser_command = 'sudo -u ipetrov xdg-open %URL% &'

augroup go_mappings
  autocmd!
  autocmd FileType go nmap <leader>err :GoIfErr<CR>
  autocmd FileType go nmap <leader>dc :GoDocBrowser<CR>
augroup END

" terraform
function! OpenURL(url)
  if a:url != ''
    let l:command = '!sudo -u ipetrov xdg-open ' . shellescape(a:url) . ' > /dev/null 2>&1 &'
    execute l:command
  endif
endfunction

function! ConvertProviderToFull(provider_short) abort
    let providers = {
        \ 'hcp': 'hashicorp/hcp/latest',
        \ 'aws': 'hashicorp/aws/latest',
        \ 'awscc': 'hashicorp/awscc/latest',
        \ 'vault': 'hashicorp/vault/latest',
        \ 'cloudflare': 'cloudflare/cloudflare/latest',
        \ 'github': 'integrations/github/latest',
        \ 'gitlab': 'gitlabhq/gitlab/latest',
        \ 'grafana': 'grafana/grafana/latest',
        \ 'artifactory': 'jfrog/artifactory/latest',
        \ 'platform': 'jfrog/platform/latest',
        \ 'project': 'jfrog/project/latest',
        \ 'kubernetes': 'hashicorp/kubernetes/latest',
        \ 'helm': 'hashicorp/helm/latest',
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
        let l:url = 'https://registry.terraform.io/providers/' . l:provider . '/docs/' . l:block_type . '/' . l:target
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
                let l:url = 'https://registry.terraform.io/providers/' . l:provider . '/docs/' . l:block_type . '/' . l:target . '\#'. l:field . '-1'
            elseif l:line =~ l:field_block_pattern
                let l:url = 'https://registry.terraform.io/providers/' . l:provider . '/docs/' . l:block_type . '/' . l:target . '\#'. l:field
            endif
            call OpenURL(l:url)
        endif
    endif
endfunction

augroup terraform_mappings
  autocmd!
  autocmd FileType terraform nnoremap <leader>dc :call TerraformDocBrowser()<CR><CR>
augroup END
