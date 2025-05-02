" vim: set foldmethod=marker:
" {{{1 Global Variables

let g:skip_defaults_vim = 1
let g:mapleader = " "
let g:vimsyn_embed = "lpP"
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth()'
let g:python_indent.continue = 'shiftwidth()'
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_list_hide = '\.venv/,\.git/'
let g:netrw_maxfilenamelen = 47
let g:netrw_mousemaps = 0
let g:netrw_sizestyle = 'H'
let g:netrw_sort_by = 'name'
let g:netrw_sort_options = 'i'
let g:netrw_sort_sequence = '[\/]\s*,*'
let g:netrw_special_syntax = v:true
let g:netrw_timefmt = '%d-%m-%Y %H:%M'
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" {{{1 Options

set cursorline
set number
set relativenumber
set mouse=a
set mousemodel=popup
set fillchars=
set fillchars+=vert:┃
set fillchars+=diff:\ 
set splitbelow
set splitright
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set nosmarttab
set foldlevelstart=99
set foldmethod=indent
set foldignore=
set guifont=Iosevka\ Custom\ 12
set completeopt=menu,menuone,preview,noinsert,noselect
set matchpairs=(:),{:},[:],<:>
set linebreak
set breakindent
set showbreak=↪\ 
set scrolloff=3
set visualbell
set noerrorbells
set undofile
set shiftround
set virtualedit=block
set termguicolors
set diffopt=
set diffopt+=vertical
set diffopt+=filler
set diffopt+=closeoff
set diffopt+=internal
set diffopt+=indent-heuristic
set diffopt+=algorithm:histogram
set hlsearch
set laststatus=2
set textwidth=0
set colorcolumn=81
set shortmess=atToOCF
set autoread
set timeout timeoutlen=1000 ttimeoutlen=0
set nocompatible
set updatetime=100
set hidden
set incsearch
set jumpoptions=stack
set statusline=\ %m\%=
            \%-5.5{&filetype}\ %-6.6{&fileencoding}\ %-4.4{&fileformat}
            \\ %4.4(%p%%%)%5.5l:%-3.3v

syntax on
filetype plugin indent on

" {{{1 Mappings

if !empty($TMUX) && executable('tmux')
    map <Leader>y "+y:call system('tmux load-buffer -w -', @+)<CR>
else
    map <Leader>y "+y
endif

map <Leader>+ :call setreg('+', @")<CR>
map <Leader>p "+p
map <Leader>P "+P

map <Leader>dp :diffput<CR>
map <Leader>do :diffget<CR>
xmap <Leader>dp :diffput<CR>
xmap <Leader>do :diffget<CR>
nmap <Leader>gd :Gdiffsplit<CR>
nmap <Leader>gc :G commit<CR>
nmap <Leader>ga :G commit --amend<CR>
nmap <Leader>gp :G push<CR>
nmap <Leader>gg :tabnew \| leftabove vert G \| vert resize 50 \| set wfw<CR>
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
map <Leader>gs <Plug>(GitGutterStageHunk)
map <Leader>gr <Plug>(GitGutterUndoHunk)
map <Leader>g? <Plug>(GitGutterPreviewHunk)
xmap < <gv
xmap > >gv
map <C-LeftMouse> <Nop>
imap <C-f> <Right>
imap <C-b> <Left>
imap <C-a> <C-o>^
imap <C-e> <C-o>$
imap <C-k> <C-o>C
imap <C-d> <C-o>x
execute "set <M-f>=\ef"
execute "set <M-b>=\eb"
execute "set <M-d>=\ed"
imap <M-f> <C-o>w
imap <M-b> <C-o>b
imap <M-d> <C-o>dw
cmap <C-f> <Right>
cmap <C-b> <Left>
cmap <C-a> <Home>
cmap <C-e> <End>
cmap <C-d> <Delete>
cmap <C-n> <Down>
cmap <C-p> <Up>
cmap <M-f> <C-Right>
cmap <M-b> <C-Left>
cmap <M-d> <C-Right><C-w>
inoremap <C-Y> <C-D>
noremap <C-l> :nohlsearch<CR>:diffupdate<CR><C-l>
nmap tn :tabnew<CR>
nmap tq :tabclose<CR>
nmap <Leader>ff :Files<CR>
nmap <Leader>fr :CwdHistory<CR>
nmap <Leader>fb :Buffers<CR>
nmap <Leader>fg :Rg ""<CR>
nmap <expr> <Leader>fe &filetype ==# 'netrw' ? ':Rex<CR>' : ':Ex<CR>'
nmap <C-w>q :bn \| bd#<CR>
nmap <Leader>tt :NERDTreeToggle<CR>

" {{{2 Default Mappings

" <C-W><S-N>    - Exit insert mode in terminal
" insert mode:
"  <C-T>           - indent, see :h i_CTRL-T
"  <C-D>           - un-indent, see :h i_CTRL-D
" normal mode:
"  <count?><C-E>   - scroll window down <count> lines, see :h CTRL-E
"  <count?><C-Y>   - scroll window up <count> lines, see :h CTRL-Y
" commands:
"  :make           - execute makeprg with given args
"  :copen          - open quickfix list
"  :cdo {cmd}      - execute {cmd} in each valid entry in the quickfix list.
"                    works like this:
"                      :cfirst
"                      :{cmd}
"                      :cnext
"                      :{cmd}
"                      etc.
"  :cn             - go to the next error in quickfix list that includes a file name
"  :cp             - go to the previous error in quickfix list that includes a file name
"  :cc [num]       - go to the specified error in quickfix list
"  @:              - repeat last command
"  :s/foo/bar/     - substitute the first match of foo with bar in the current line
"  :s/foo/bar/g    - same as above but for all matches in the current line
"  :%s/foo/bar/g   - same as above, but for all lines in buffer
"  :%s/foo/bar/gc  - same as above but asking for confirmation on each match
"  :lua << EOF     - run a lua snippet using lua-heredoc syntax
"  local tbl = {1, 2, 3}
"  for k, v in ipairs(tbl) do
"    print(v)
"  end
"  EOF

" {{{1 Autocommands

" Return cursor to last position in buffer
autocmd BufReadPost * silent! normal! g`"zv

" Filetype specific config
autocmd FileType go setlocal noexpandtab
autocmd FileType c,cpp
    \ setlocal tabstop=2 |
    \ setlocal softtabstop=2 |
    \ setlocal shiftwidth=2
autocmd FileType netrw nmap <buffer> <C-h> -
autocmd FileType netrw nmap <buffer> <C-l> <CR>
autocmd VimEnter * :clearjumps

" {{{1 Custom commands
command! W write

" {{{1 Plugins
" {{{2 Plugin variables

" {{{3 GitGutter

let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '┃'

" {{{3 Colorizer

let g:colorizer_colornames = 0

" {{{3 NERDTree

let g:NERDTreeDirArrowCollapsible = ""
let g:NERDTreeDirArrowExpandable = ""
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI = 1
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeRemoveFileCmd = "gio trash "
let g:NERDTreeRemoveDirCmd = "gio trash "
let g:NERDTreeMapActivateNode = "l"
let g:NERDTreeMapCloseDir = "h"

" {{{2 Install
let s:plug_file = expand('$HOME/.vim/autoload/plug.vim')
if !filereadable(s:plug_file)
    silent execute '!curl -fkLo ' . s:plug_file ' --create-dirs'
        \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let s:plug_dir = expand('$HOME/.vim/plugged')
call plug#begin(s:plug_dir)
    Plug 'joshdick/onedark.vim'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'markonm/traces.vim'
    Plug 'rbong/vim-flog'
    Plug 'chrisbra/Colorizer'
    Plug 'jceb/vim-orgmode'
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'

    " Plug 'prabirshrestha/vim-lsp'
    " Plug 'dense-analysis/ale' 
    " Plug 'prabirshrestha/asyncomplete.vim'
    " Plug 'prabirshrestha/asyncomplete-lsp.vim'

    " Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Plug 'https://github.com/yegappan/lsp'

    " Some notes:
    " * ALE doesn't support semantic highlighting
    " * vim-lsp doesn't support clangd switch to header/source or request document
    "   highlight on cursor or request diagnostic float on cursor
    " * CoC flickers in C++/clangd when semanticTokens is enabled
    " * lsp slow loading new buffers
    " * YouCompleteMe ??? haven't tried but supports semantic highlighting
    " 
    " To conclude, vim-lsp + asynccomplete + ALE seems to be the best stack.
    " Disabling LSP stuff for now.
call plug#end()

" {{{2 Colorscheme

silent! colorscheme onedark

" {{{2 Fzf

function! s:build_quickfix_list(lines)
    echo "lines"
    echo lines
    call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
    copen
    cc
endfunction

autocmd! FileType fzf tnoremap <buffer> <C-k> <Up>
autocmd! FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd! FileType fzf tnoremap <buffer> <C-l> <CR>

" To match exact, prefix word with `'`
command! -bang -nargs=* Rg call fzf#vim#grep(
    \ "rg"
    \ . " --column"
    \ . " --line-number"
    \ . " --no-heading"
    \ . " --color=always"
    \ . " --smart-case"
    \ . " --iglob=!.git"
    \ . " --hidden"
    \ . " --no-ignore-vcs " .<q-args>, 1, <bang>0)

command! -bang CwdHistory call fzf#run(fzf#wrap({
    \ 'source': filter(
    \   fzf#vim#_recent_files(),
    \   'v:val !~ "^\\~\\?/"'
    \ ),
    \ 'options': [
    \   '-m',
    \   '--header-lines', !empty(expand('%')),
    \   '--prompt', 'CwdHist> '
    \ ]},
    \ <bang>0))

" {{{2 flog

nmap <Leader>gl :Flog<CR>

" {{{2 vim-lsp

" let g:lsp_use_native_client = 1
" let g:lsp_semantic_enabled = 1
" let g:lsp_format_sync_timeout = 1000
" let g:lsp_document_code_action_signs_enabled = 0
" let g:lsp_document_highlight_enabled = 0
" let g:lsp_diagnostics_virtual_text_enabled = 1
" let g:lsp_diagnostics_virtual_text_align = 'after'
" let g:lsp_diagnostics_virtual_text_padding_left = 5
" let g:lsp_diagnostics_virtual_text_wrap = 'truncate'

" highlight! link lspReference Visual

" if executable('pyright')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyright',
"         \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
"         \ 'allowlist': ['python'],
"         \ 'workspace_config': {
"         \   'python': {
"         \     'analysis': {
"         \       'autoSearchPaths': v:true,
"         \       'diagnosticMode': 'openFilesOnly',
"         \       'useLibraryCodeForTypes': v:true,
"         \       'typeCheckingMode': 'off'
"         \     }
"         \   }
"         \ }})
" endif

" if executable('clangd')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'clangd',
"         \ 'cmd': {server_info->[
"         \   'clangd',
"         \   '--clang-tidy',
"         \   '--enable-config',
"         \   '--compile-commands-dir=build'
"         \ ]},
"         \ 'allowlist': ['c', 'cpp'],
"         \ })
" endif

" function! s:on_lsp_buffer_enabled() abort
"     setlocal omnifunc=lsp#complete
"     setlocal signcolumn=yes
"     if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
"     nmap <buffer> gd <plug>(lsp-definition)
"     nmap <buffer> gs <plug>(lsp-document-symbol-search)
"     nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
"     nmap <buffer> gr <plug>(lsp-references)
"     nmap <buffer> gi <plug>(lsp-implementation)
"     nmap <buffer> gD <plug>(lsp-type-definition)
"     nmap <buffer> <leader>lr <plug>(lsp-rename)
"     nmap <buffer> [d <plug>(lsp-previous-diagnostic)
"     nmap <buffer> ]d <plug>(lsp-next-diagnostic)
"     nmap <buffer> <C-k> <plug>(lsp-hover-float)
"     imap <buffer> <C-k> <C-o><plug>(lsp-hover-float)
"     nmap <buffer> <C-j> <plug>(lsp-signature-help)
"     imap <buffer> <C-j> <C-o><plug>(lsp-signature-help)
"     nmap <buffer> <C-h> <plug>(lsp-document-symbol)
"     nmap <buffer> <Leader>ld <plug>(lsp-document-diagnostics)

"     inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"     inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"     inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

"     nmap <buffer> <Leader>la <plug>(lsp-code-action-float)

"     " function! s:check_back_space() abort
"     "     let col = col('.') - 1
"     "     return !col || getline('.')[col - 1]  =~ '\s'
"     " endfunction

"     " inoremap <silent><expr> <TAB>
"     "     \ pumvisible() ? "\<C-n>" :
"     "     \ <SID>check_back_space() ? "\<TAB>" :
"     "     \ asyncomplete#force_refresh()
"     " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"     " let g:lsp_format_sync_timeout = 1000
"     " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

" 	augroup lsp_float_colours
"         autocmd!
"         autocmd User lsp_float_opened
"                     \ call popup_setoptions(lsp#document_hover_preview_winid(),
"                     \   #{borderchars: [
"                     \       ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
"                     \   ],
"                     \   border: [0, 1, 0 ,1]
"                     \ })
"     augroup end
" endfunction

" augroup lsp_install
"     au!
"     " call s:on_lsp_buffer_enabled only for languages that has the server registered.
"     autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
" augroup END

" {{{2 CoC

" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1) :
"       \ CheckBackspace() ? "\<Tab>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<Nop>"

" " Make <CR> to accept selected completion item or notify coc.nvim to format
" " <C-g>u breaks current undo, please make your own choice
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" function! CheckBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" " Use `[d` and `]d` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
" nmap <silent> [d <Plug>(coc-diagnostic-prev)
" nmap <silent> ]d <Plug>(coc-diagnostic-next)

" " GoTo code navigation
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gD <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" " Use K to show documentation in preview window
" nmap <silent> <C-k> :call ShowDocumentation()<CR>
" imap <silent> <C-k> <C-o>:call CocActionAsync('showSignatureHelp')<CR>

" function! ShowDocumentation()
"   if CocAction('hasProvider', 'hover')
"     call CocActionAsync('doHover')
"   endif
" endfunction

" " Highlight the symbol and its references
" nmap <silent> <C-h> :call CocActionAsync('highlight')<CR>

" " Symbol renaming
" nmap <leader>rn <Plug>(coc-rename)

" " Formatting selected code
" xmap <leader>lf  <Plug>(coc-format-selected)
" nmap <leader>lf  :call CocActionAsync('format')<CR>

" " Applying code actions to the selected code block
" xmap <leader>la  <Plug>(coc-codeaction-selected)
" nmap <leader>la  <Plug>(coc-codeaction-selected)

" {{{2 lsp

" autocmd User LspSetup call LspOptionsSet(#{
"     \   aleSupport: v:false,
"     \   autoComplete: v:true,
"     \   autoHighlight: v:false,
"     \   autoHighlightDiags: v:true,
"     \   autoPopulateDiags: v:false,
"     \   completionMatcher: 'case',
"     \   completionMatcherValue: 1,
"     \   diagSignErrorText: 'E',
"     \   diagSignHintText: 'H',
"     \   diagSignInfoText: 'I',
"     \   diagSignWarningText: 'W',
"     \   echoSignature: v:false,
"     \   hideDisabledCodeActions: v:false,
"     \   highlightDiagInline: v:true,
"     \   hoverInPreview: v:false,
"     \   ignoreMissingServer: v:false,
"     \   keepFocusInDiags: v:true,
"     \   keepFocusInReferences: v:true,
"     \   completionTextEdit: v:true,
"     \   diagVirtualTextAlign: 'above',
"     \   diagVirtualTextWrap: 'default',
"     \   noNewlineInCompletion: v:false,
"     \   omniComplete: v:null,
"     \   outlineOnRight: v:false,
"     \   outlineWinSize: 20,
"     \   semanticHighlight: v:false,
"     \   showDiagInBalloon: v:true,
"     \   showDiagInPopup: v:true,
"     \   showDiagOnStatusLine: v:true,
"     \   showDiagWithSign: v:true,
"     \   showDiagWithVirtualText: v:false,
"     \   showInlayHints: v:true,
"     \   showSignature: v:true,
"     \   snippetSupport: v:false,
"     \   ultisnipsSupport: v:false,
"     \   useBufferCompletion: v:false,
"     \   usePopupInCodeAction: v:false,
"     \   useQuickfixForLocations: v:false,
"     \   vsnipSupport: v:false,
"     \   bufferCompletionTimeout: 100,
"     \   customCompletionKinds: v:false,
"     \   completionKinds: {},
"     \   filterCompletionDuplicates: v:false,
"     \ })

" autocmd User LspSetup call LspAddServer([#{
"     \   name: 'clangd',
"     \   filetype: ['c', 'cpp'],
"     \   path: 'clangd',
"     \   args: [
"     \       '--background-index',
"     \       '--clang-tidy',
"     \       '--enable-config',
"     \       "--compile-commands-dir=build",
"     \   ]
"     \ }])

" {{{2 ALE

" let g:ale_linters_explicit = 1
" let g:ale_linters = #{
"     \     python: ['flake8'],
"     \ }
" let g:ale_python_flake8_options = '--max-line-length=80 --max-doc-length=80'

" let g:ale_fixers = #{
"     \     python: ['black', 'isort', 'remove_trailing_lines', 'trim_whitespace'],
"     \ }
" let g:ale_python_black_options = '--line-length 80'

" {{{1 Statusline

function! GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
    let parts = []

    if a > 0
        let parts += ['%#GitStatusAdd#' . printf('+%d', a) . '%*']
    endif

    if m > 0
        let parts += ['%#GitStatusChange#' . printf('~%d', m) . '%*']
    endif

    if r > 0
        let parts += ['%#GitStatusDelete#' . printf('-%d', r) . '%*']
    endif

    if empty(parts)
        return ''
    endif

    return ' ' . join(parts, ' ')
endfunction
 
function! s:SetupGitGutter()
    if !exists('g:loaded_gitgutter')
        return
    endif

    execute 'highlight default GitStatusAdd guifg='
        \ . synIDattr(synIDtrans(hlID('GitGutterAdd')), 'fg')
        \ . ' guibg='
        \ . synIDattr(synIDtrans(hlID('StatusLine')), 'bg')
    execute 'highlight GitStatusChange guifg='
        \ . synIDattr(synIDtrans(hlID('GitGutterChange')), 'fg')
        \ . ' guibg='
        \ . synIDattr(synIDtrans(hlID('StatusLine')), 'bg')
    execute 'highlight GitStatusDelete guifg='
        \ . synIDattr(synIDtrans(hlID('GitGutterDelete')), 'fg')
        \ . ' guibg='
        \ . synIDattr(synIDtrans(hlID('StatusLine')), 'bg')

    set statusline=\ %f%{%GitStatus()%}\ %m
        \%=
        \%-5.5{&filetype}\ %-6.6{&fileencoding}\ %-4.4{&fileformat}
        \\ %4.4(%p%%%)%5.5l:%-3.3v
endfunction

function! s:SetupNERDTree()
    if !exists('g:loaded_nerd_tree')
        return
    endif

    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 &&
                \ winnr('$') == 1 &&
                \ exists('b:NERDTree') &&
                \ b:NERDTree.isTabTree() |
                \ quit |
                \ endif

    " Start NERDTree and put the cursor back in the other window.
    NERDTree | wincmd p
endfunction

autocmd VimEnter * call s:SetupGitGutter()
autocmd VimEnter * call s:SetupNERDTree()
