call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'luisiacc/gruvbox-baby'
Plug 'ziglang/zig.vim'
Plug 'mateuszradomski/tableize.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
call plug#end()

colorscheme gruvbox-baby

set noswapfile
set cino+=(0
set cino+=l1
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

nnoremap <silent> <leader>n :cn<CR>
nnoremap <silent> <leader>p :cp<CR>
nnoremap <silent> <leader>v :NvimTreeToggle<CR>
nnoremap <silent> <leader>b :NvimTreeFindFile<CR>

nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <C-y> :Files<CR>
nnoremap <silent> <C-l> :Buffers<CR>
nnoremap <silent> <leader>f :Rg<CR>
nnoremap <silent> <leader>t :Tableize<CR>

lua << EOF
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

require'lspconfig'.tsserver.setup{}
require'lspconfig'.rust_analyzer.setup{}

lsp.setup()

-- Disable this stupid LSP formatexpr that disallows me to do `gq`
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
    vim.bo[args.buf].formatexpr = nil
    end,
})
EOF

lua << EOF
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup()
EOF

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
