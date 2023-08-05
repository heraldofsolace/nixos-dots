vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = 'abdmg'
vim.g.vimtex_compiler_progname = 'nvr'

vim.g.vimtex_compiler_latexmk = {
    backend = 'nvim',
    background = 1,
    build_dir = '',
    callback = 1,
    continuous = 1,
    executable = 'latexmk',
    options = {
        '-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode'
    }
}

local keymaps = {
    {'<leader>cl', '<plug>(vimtex-compile)'},
    {'<leader>cL', '<plug>(vimtex-compile-selected)'},
    {'<leader>vl', ':VimtexView<cr>'},

    {
        '<C-f> <Esc>',
        [[: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>]],
        mode='i',
        opts={noremap=true}
    },
    {
        '<leader><C-f>',
        [[: silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>]],
        opts={noremap=true}
    },
}

require('legendary').keymaps(keymaps)