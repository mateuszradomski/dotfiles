call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'neovim/nvim-lspconfig'
Plug 'vim-scripts/a.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'luisiacc/gruvbox-baby'
Plug 'L3MON4D3/LuaSnip'
Plug 'mateuszradomski/tableize.vim'
call plug#end()

colorscheme gruvbox-baby

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

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
lua require'treesitter-context'.setup { enable = true, max_lines = 0, patterns = { default = { 'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case', }, }, }

set grepprg=rg\ --vimgrep\ --smart-case

let mapleader = " "
nnoremap <SPACE> <nop>

nnoremap * *N
nnoremap <leader>s :A<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-;> :Files<CR>
nnoremap <C-l> :Buffers<CR>

nnoremap <leader>t :Tableize<CR>
noremap <leader><leader> <c-^>

lua << EOF
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

end

require'lspconfig'.clangd.setup{ on_attach = on_attach }
EOF

lua << EOF
local ls = require("luasnip")

ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

ls.add_snippets("all", {
    ls.parser.parse_snippet("ifd", "#ifdef $1\n\t$2\n#endif"),
    ls.parser.parse_snippet("ifde", "#ifdef $1\n\t$2\n#else\n\t$3\n#endif"),
})

vim.keymap.set({ "i", "s" }, "<c-g>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })
EOF

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
