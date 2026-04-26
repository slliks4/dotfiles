" Basic
let g:netrw_banner = 0

" UI (global statusline not in 0.6: use laststatus=2)
set laststatus=2
set showmode
set ruler
set cmdheight=1

" Jump to EOF on startup
augroup MyEnter
  autocmd!
  autocmd VimEnter * normal! G
augroup END

" Fat cursor
set guicursor=n-v-c-i:block

" Relative numbers, including in netrw
augroup MyNetrw
  autocmd!
  autocmd FileType netrw setlocal relativenumber number
augroup END
set number
set relativenumber

" Indent
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Search
set nohlsearch
set incsearch

" Viewport / signs / perf / colors
set scrolloff=8
set signcolumn=yes
set updatetime=50
set termguicolors

" Leader
let mapleader = " "

" Clipboard y/p/d
nnoremap <silent> <leader>y "+y
vnoremap <silent> <leader>y "+y
nnoremap <silent> <leader>Y "+yy
nnoremap <silent> <leader>p "+p
vnoremap <silent> <leader>p "+p
nnoremap <silent> <leader>P "+P
vnoremap <silent> <leader>P "+P
nnoremap <silent> <leader>d "+dd
vnoremap <silent> <leader>d "+d
nnoremap <silent> <leader>D "+dd

" Delete without yanking
nnoremap <silent> <leader>x "_d
vnoremap <silent> <leader>x "_d
nnoremap <silent> <leader>X "_dd

" Project view (netrw)
nnoremap <silent> <leader>e :Ex<CR>

" Splits and movement
nnoremap <silent> <leader>V <C-w>v<C-w>l
nnoremap <silent> <leader>H <C-w>s<C-w>j
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Visual indent with Tab / S-Tab
vnoremap <silent> <Tab> >gv
vnoremap <silent> <S-Tab> <gv

" Alternate file
nnoremap <silent> <leader>b <C-^>

" Save / quit
nnoremap <silent> <leader>q :q<CR>
vnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>w :w<CR>
vnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>W :wa<CR>

" Transparent backgrounds
highlight Normal guibg=NONE ctermbg=NONE
highlight NormalNC guibg=NONE ctermbg=NONE
highlight NormalFloat guibg=NONE ctermbg=NONE
highlight Pmenu guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE ctermbg=NONE
highlight VertSplit guibg=NONE ctermbg=NONE
