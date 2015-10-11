" Part of the "sysrq dotfiles experience". Available at:
"    sysrq <chris@gibsonsec.org> https://github.com/sysr-q/dotfiles
"
" This is free and unencumbered software released into the public domain.
"
" Anyone is free to copy, modify, publish, use, compile, sell, or
" distribute this software, either in source code form or as a compiled
" binary, for any purpose, commercial or non-commercial, and by any
" means.
"
" In jurisdictions that recognize copyright laws, the author or authors
" of this software dedicate any and all copyright interest in the
" software to the public domain. We make this dedication for the benefit
" of the public at large and to the detriment of our heirs and
" successors. We intend this dedication to be an overt act of
" relinquishment in perpetuity of all present and future rights to this
" software under copyright law.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
" OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
" ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
" OTHER DEALINGS IN THE SOFTWARE.
"
" For more information, please refer to <http://unlicense.org>

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set nocompatible

let mapleader = ","
map <C-n> :NERDTreeToggle<CR>
map <C-m> :GitGutterToggle<CR>
nnoremap ; :
" Make j/k a bit more "natural" by going down the wrapped line, not actual.
nnoremap j gj
nnoremap k gk
nmap <silent> <leader>/ :nohlsearch<CR>

let NERDTreeIgnore = ['\.pyc$', '__pycache__$']

set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:go_fmt_autosave = 1
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)

syntax enable
set background=dark
colorscheme solarized
highlight clear SignColumn

" TODO: comment these and arrange them.
set tabstop=4
set smartindent
set shiftwidth=4
set backspace=indent,eol,start
set cc=80
set cursorline
set number
set modeline
set hidden
set scrolloff=10
set smartcase
set splitbelow
set splitright
set shortmess+=I " I probably won't donate buddy.
set title

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" NeoVim related stuff.
set timeout
set timeoutlen=750
set ttimeoutlen=250

" NeoVim handles ESC keys as alt+key, set this to solve the problem
if has('nvim')
	set mouse=
	set ttimeout
	set ttimeoutlen=0
endif
