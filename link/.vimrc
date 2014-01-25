runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

syntax enable
set background=dark
colorscheme solarized
highlight clear SignColumn

set number
set tabstop=4
set shiftwidth=4
set cc=80
set cursorline

map <C-n> :NERDTreeToggle<CR>
map <C-m> :GitGutterToggle<CR>
