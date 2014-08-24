runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

let mapleader = ","
map <C-n> :NERDTreeToggle<CR>
map <C-m> :GitGutterToggle<CR>

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

set number
set tabstop=4
set shiftwidth=4
set cc=80
set cursorline
