local keymaps = {
    {'<leader>ff', ':Telescope find_files<cr>', opts={noremap=true}},
    {'<leader>fg', ':Telescope live_grep<cr>', opts={noremap=true}},
    {'<leader>fb', ':Telescope buffers<cr>', opts={noremap=true}},
    {'<leader>fh', ':Telescope help_tags<cr>', opts={noremap=true}},
    {'<leader>fo', ':Telescope oldfiles<cr>', opts={noremap=true}},
    {'<leader>ft', ':Telescope tags<cr>', opts={noremap=true}},
    {'<leader>fc', ':Telescope commands<cr>', opts={noremap=true}},
    {'<leader>fr', ':Telescope registers<cr>', opts={noremap=true}},
    {'<leader>fk', ':Telescope keymaps<cr>', opts={noremap=true}},
    {'<leader>fgc', ':Telescope git_commits<cr>', opts={noremap=true}},
    {'<leader>fgb', ':Telescope git_bcommits<cr>', opts={noremap=true}},
    {'<leader>fcf', ':Telescope current_buffer_fuzzy_find<cr>', opts={noremap=true}},
    {'<leader>fbm', ':Telescope marks<cr>', opts={noremap=true}},
    {'<leader>ccs', ':Telescope colorscheme<cr>', opts={noremap=true}},
    {'<leader><leader>', ':Telescope frecency', opts={noremap=true}}
}

require('legendary').keymaps(keymaps)