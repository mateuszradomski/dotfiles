call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'
Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/a.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'luisiacc/gruvbox-baby'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'mbbill/undotree'
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

lua <<EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = { },
    window = { },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({{ 
          name = 'buffer',
          option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
      }})
  })
EOF

set grepprg=rg\ --vimgrep\ --smart-case

let mapleader = " "
nnoremap <SPACE> <nop>

nnoremap * *N
nnoremap <leader>s :A<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-l> :Buffers<CR>
nnoremap <C-P> :Files<CR>
nnoremap <C-y> :UndotreeToggle<CR>

nnoremap <leader>pv :Ex<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>ga :Git fetch --all<CR>
nnoremap <leader>grum :Git rebase upstream/master<CR>
nnoremap <leader>grom :Git rebase origin/master<CR>

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

require'lspconfig'.clangd.setup{ on_attach=on_attach }
EOF

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
