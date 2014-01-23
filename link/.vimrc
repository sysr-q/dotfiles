runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set laststatus=2
let g:airline_powerline_fonts = 1

syntax enable
set background=dark
colorscheme solarized

set number
set cindent
set tabstop=4
set shiftwidth=4

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
