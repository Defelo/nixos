{{#if vim.plugins.airline}}
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_theme = 'nord'
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:powerline_pycmd="py3"
{{/if}}

let g:markdown_fenced_languages = ["python", "java"]
let g:markdown_minlines = 100

let g:livepreview_previewer = 'okular'

set nu rnu

set clipboard=unnamedplus " sync vim clipboard with linux clipboard

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

set so=7

" set mouse=a

set updatetime=1000

autocmd FileType yaml setlocal shiftwidth=2
autocmd FileType text setlocal textwidth=0
autocmd FileType text setlocal wrapmargin=0

source ~/.config/nvim/plugins.vim

colorscheme nord
