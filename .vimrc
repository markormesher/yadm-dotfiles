set nocompatible
syntax on

" custom leader key
let mapleader=","

" dont re-draw during macros
set lazyredraw

" highlight changes/replacements using `s` as they're typed (neovim only)
set inccommand=nosplit

" make searches without caps case-insensitive
set smartcase
set ignorecase

" keep undo history even after exiting
set undofile

" some servers have issues with backup files
set nobackup
set nowritebackup

" default tab size of 2 spaces (may be overwritten by vim-sleuth)
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" hide buffers when abandoned
set hidden

" show current line number and relative numbers on other lines
set number relativenumber

" always show the sign column to avoid janky changes when signs appear/disappear
set signcolumn=yes

" keep the cursor X lines away from the top and bottom of the window (except for the start and end of files)
set scrolloff=10

" more space for messages
set cmdheight=2

" don't pass messages to |ins-completion-menu|.
set shortmess+=c

" set file types
filetype plugin on
autocmd BufRead,BufNewFile *.json set filetype=jsonc

call plug#begin()

" vimwiki plugin
Plug 'vimwiki/vimwiki'

" vim interface
Plug 'scrooloose/nerdtree' " file browser
Plug 'vim-airline/vim-airline' " status line
Plug 'kshenoy/vim-signature' " show marks in the gutter
Plug 'junegunn/vim-peekaboo' " register previews
Plug 'voldikss/vim-floaterm' " floating terminal

" fzf file search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" generic typing/coding assistance
Plug 'tpope/vim-commentary' " gcc to (un-)comment a line, gc to (un-)comment a visual selection
Plug 'tpope/vim-sleuth' " detect the indentation style for a file and adjust settings accordingly
Plug 'alvan/vim-closetag' " auto close XML/HTML tags
Plug 'ntpeters/vim-better-whitespace' " highlight trailing whitespace and provides :StripWhitespace helper
Plug 'unblevable/quick-scope' " highlight good options for f and F navigation within a line

" TS language support
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'

" openhab syntax highlighting
Plug 'cyberkov/openhab-vim'

" auto-complete and language server support
Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': { -> coc#util#install() } }

" colour schemes
Plug 'dracula/vim', { 'as': 'dracula' }

" general UI
Plug 'blueyed/vim-diminactive' " dim inactive vim windows

call plug#end()

" vimwiki settings
let g:vimwiki_global_ext = 0
let g:vimwiki_auto_header = 1
let g:vimwiki_table_mappings = 0
let g:vimwiki_list = [{
      \ 'path': '~/vimwiki/',
      \ 'syntax': 'markdown',
      \ 'ext': '.md',
      \ 'auto_diary_index': 1
      \ }]

" NERDTree settings
let NERDTreeShowHidden=1 " always show dot files
let NERDTreeQuitOnOpen=1 " quit NERDTree after opening a file
map <Leader>m :NERDTreeToggle<CR>
map <Leader>n :NERDTreeFind<CR>
autocmd BufEnter NERD_tree_* | execute 'normal R'

" FZF file finder settings
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
noremap <Leader>, :Files<CR>
map <Leader>. :Ag<CR>

" <leader>-c redraws the screen and removes any search highlighting.
map <Leader>c :nohl<CR> :redraw!<CR>

" shortcut for floaterm
nnoremap <silent> <C-Space> :FloatermToggle<CR>
tnoremap <silent> <C-Space> <C-\><C-n>:FloatermToggle<CR>
let g:floaterm_autoclose = 2 " close the terminal when the shell exits

" closetag settings
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.jsx,*.tsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'

" coc settings (more settings in ~/.config/nvim/coc-settings.json)
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-java',
      \ 'coc-sh',
      \ 'coc-diagnostic',
      \ 'coc-spell-checker',
      \ 'coc-pairs'
      \ ]
nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <Leader>rn <Plug>(coc-rename)
map <Leader>f <Plug>(coc-codeaction-line)
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" strip whitespace just before saving files
:autocmd BufWritePre * :StripWhitespace

" colour scheme + edits
let g:dracula_colorterm = 0
:silent! colorscheme dracula

highlight QuickScopePrimary cterm=underline
highlight QuickScopeSecondary cterm=underline,italic

highlight CocErrorSign ctermfg=DarkRed
highlight CocErrorVirtualText ctermfg=DarkRed
highlight CocErrorHighlight cterm=underline

highlight CocWarningSign ctermfg=DarkYellow
highlight CocWarningVirtualText ctermfg=DarkYellow
highlight CocWarningHighlight cterm=underline

highlight CocInfoSign ctermfg=Cyan
highlight CocInfoVirtualText ctermfg=Cyan
highlight CocInfoHighlight cterm=underline

highlight CocHintSign ctermfg=Cyan
highlight CocHintVirtualText ctermfg=Cyan
highlight CocInfoHighlight cterm=underline
