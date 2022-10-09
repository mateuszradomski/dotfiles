call plug#begin('~/.vim/plugged')
Plug 'nathom/filetype.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'L3MON4D3/LuaSnip'
Plug 'ziglang/zig.vim'
Plug 'mateuszradomski/tableize.nvim'
Plug 'mateuszradomski/alternate.nvim'
call plug#end()

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
set cmdheight=0

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
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }
vim.keymap.set({ "i", "s" }, "<c-g>", function() if ls.expand_or_jumpable() then ls.expand_or_jump() end end, { silent = true })

ls.add_snippets("all", {
    ls.parser.parse_snippet("todo", "TODO(radomski): "),
    ls.parser.parse_snippet("note", "NOTE(radomski): "),
})

local csnip = {
    s("ifd", fmt("#ifdef {}\n\t{}\n#endif", { i(1, ""), i(2, "") })),
    s("ifde", fmt("#ifdef {}\n\t{}\n#else\n\t{}\n#endif", { i(1, ""), i(2, ""), i(3, "") })),
    s("htop", fmt("#ifndef {}\n#define {}\n{}\n#endif", { i(1, ""), rep(1), i(2, "") })),
    s("for", fmt("for({} {} = 0; {} < {}; {}++)\n{{\n\t{}\n}}", { i(1, "int"), i(2, "i"), rep(2), i(3, ""), rep(2), i(4, "") })),
    s("ife", fmt("if({}) {{\n\t{}\n}} else {{\n\t{}\n}}", { i(1, ""), i(2, ""), i(3, "") })),
    s("tds", fmt("typedef struct {} \n{{\n\t{}\n}} {};", { i(1, ""), i(2, ""), rep(1) })),
    s("pr", fmt("printf(\"{}\\n\");", { i(1, "") })),
    s("prv", fmt("printf(\"{} = {}\\n\", {});", { i(1, ""), i(2, "%u"), rep(1) })),
    s("main", fmt("#include <stdio.h>\n\nint main(int argc, char **argv)\n{{\n\t{}\n\n\treturn 0;\n}}", { i(1, "") })),
}

ls.add_snippets("cpp", csnip)
ls.add_snippets("c", csnip)
EOF

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
