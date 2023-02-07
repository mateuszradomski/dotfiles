call plug#begin('~/.vim/plugged')
Plug 'nathom/filetype.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'ziglang/zig.vim'
Plug 'mateuszradomski/tableize.nvim'
Plug 'mateuszradomski/alternate.nvim'
Plug 'mateuszradomski/untitled'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
call plug#end()

colorscheme untitled

set noswapfile
set cino+=(0
set relativenumber
set incsearch
set undofile
set undodir=$HOME/.vim/undo
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set grepprg=rg\ --vimgrep\ --smart-case

let mapleader = " "
nnoremap <SPACE> <nop>

nnoremap * *N
noremap <leader><leader> <c-^>

nnoremap <leader>fs :grep
nnoremap <silent> <leader>fw "ryiw:grep <C-R>r<CR>
nnoremap <silent> <leader>n :cn<CR>
nnoremap <silent> <leader>p :cp<CR>

nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <C-y> :Files<CR>
nnoremap <silent> <C-l> :Buffers<CR>
nnoremap <silent> <leader>s :Alternate<CR>
nnoremap <silent> <leader>t :Tableize<CR>
vnoremap <Enter> :EasyAlign<CR>

lua << EOF
require'nvim-treesitter.configs'.setup {
    incremental_selection = { enable = true },
}
EOF

lua require'treesitter-context'.setup { enable = true, max_lines = 0, patterns = { default = { 'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case', }, }, }

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
