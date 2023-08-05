local keymaps = {
    {'<Up>', '<Plug>SchleppUp', opts={unique=true}, mode='v'},
    {'<Down>', '<Plug>SchleppDown', opts={unique=true}, mode='v'},
    {'<Left>', '<Plug>SchleppLeft', opts={unique=true}, mode='v'},
    {'<Right>', '<Plug>SchleppRight', opts={unique=true}, mode='v'},

    {'<Plug>SchleppToggleReindent', opts={unique=true}, mode={'v', 'i'}},

    {'Dk', '<Plug>SchleppDupUp', opts={unique=true}, mode='v'},
    {'Dj', '<Plug>SchleppDupDown', opts={unique=true}, mode='v'},
    {'Dh', '<Plug>SchleppDupLeft', opts={unique=true}, mode='v'},
    {'Dl', '<Plug>SchleppDupRight', opts={unique=true}, mode='v'},
}

require('legendary').keymaps(keymaps)