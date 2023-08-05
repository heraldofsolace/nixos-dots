local keymaps = {
    -- Splits
    {'<leader>|', ':vsplit<cr>'},
    {'<leader>-', ':split<cr>'},
    -- No-op for arrows
    {'<Up>', ''},
    {'<Down>', ''},
    {'<Left>', ''},
    {'<Right>', ''},

    -- Save
    {'<leader>w', ':w!<cr>'},
    
    -- Search
    {'*', ":<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>", opts={noremap=true}, mode='v'},
    {'#', ":<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>", opts={noremap=true}, mode='v'},

    -- Window navigation
    {'<C-j>', '<C-W>j'},
    {'<C-k>', '<C-W>k'},
    {'<C-h>', '<C-W>h'},
    {'<C-l>', '<C-W>l'},

    -- Buffer and tabs
    {'<leader>bd', ':Bclose<cr>:tabclose<cr>gT'},
    {'<leader>ba', ':bufdo bd<cr>'},
    {'<leader>l', ':BufferLineCycleNext<cr>'},
    {'<leader>h', ':BufferLineCyclePrevious<cr>'},
    {'<leader>tn', ':tabnew<cr>'},
    {'<leader>tc', ':tabclose<cr>'},
    {'<leader>tm', ':tabmove'},
    {'<leader>tt', ':tabnext<cr>'},
    {'<leader>tl', ':exe "tabn ".g:lasttab<CR>'},
    {'<leader>te', ':tabedit <c-r>=expand("%:p:h")<cr>/'},
    -- Scrolling with j and k
    {'j', 'gj'},
    {'k', 'gk'},

    -- Spell
    {'<leader>sn', ']s'},
    {'<leader>sp', '[s'},
    {'<leader>sa', 'zg'},
    {'<leader>s?', 'z='},
    {'<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', mode='i'},

    -- cd
    {'<leader>cd', ':cd %:p:h<cr>:pwd<cr>'},

    -- Buffer
    {'<leader>q', ':e ~/buffer<cr>'},

    -- Command-mode
    {'$h', 'e ~/', mode='c', opts={noremap=true}},
    {'$d', 'e ~/Desktop/', mode='c', opts={noremap=true}},
    {'$j', 'e ./', mode='c', opts={noremap=true}},
    {'$c', 'e <C-\\>e CurrentFileDir("e")<cr>', mode='c', opts={noremap=true}},
    {'$q', '<C-\\>e DeleteTillSlash()<cr>', mode='c', opts={noremap=true}},

    -- Readline-like mappings
    {'<C-A>', '<Home>', mode='c'},
    {'<C-E>', '<End>', mode='c'},
    {'<C-K>', '<C-U>', mode='c'},
    {'<C-P>', '<Up>', mode='c'},
    {'<C-N>', '<Down>', mode='c'},
}

require('legendary').keymaps(keymaps)

vim.api.nvim_exec(
    [[
        command! Bclose call BufcloseCloseIt()
        function! BufcloseCloseIt()
            let l:currentBufNum = bufnr("%")
            let l:alternateBufNum = bufnr("#")

            if buflisted(l:alternateBufNum)
                buffer #
            else
                bnext
            endif

            if bufnr("%") == l:currentBufNum
                new
            endif

            if buflisted(l:currentBufNum)
                execute("bdelete! ".l:currentBufNum)
            endif
        endfunction

        function! CmdLine(str)
            call feedkeys(":" . a:str)
        endfunction 

        function! VisualSelection(direction, extra_filter) range
            let l:saved_reg = @"
            execute "normal! vgvy"

            let l:pattern = escape(@", "\\/.*'$^~[]")
            let l:pattern = substitute(l:pattern, "\n$", "", "")

            if a:direction == 'gv'
                call CmdLine("Ack '" . l:pattern . "' " )
            elseif a:direction == 'replace'
                call CmdLine("%s" . '/'. l:pattern . '/')
            endif

            let @/ = l:pattern
            let @" = l:saved_reg
        endfunction
    ]],
    false
)

vim.api.nvim_exec(
    [[
        func! DeleteTillSlash()
            let g:cmd = getcmdline()
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
            

            if g:cmd == g:cmd_edited
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
            endif
            
            return g:cmd_edited
        endfunc

        func! CurrentFileDir(cmd)
            return a:cmd . " " . expand("%:p:h") . "/"
        endfunc
    ]],
    false
)

local autocmds = {
    {
        'TabLeave',
        function() 
            vim.g.lasttab = vim.fn.tabpagenr() 
        end
    },
    {
        'BufReadPost',
        function()
            if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
                vim.api.nvim_command("normal! g'\"")
            end
        end
    },
    {
        'WinEnter',
        function()
            if (vim.bo.filetype ~= 'dashboard') then
                vim.opt.colorcolumn = "120"
                vim.opt.cul = true
            end
        end
    },
    {
        'WinLeave',
        function()
            if(vim.bo.filetype ~= 'dashboard') then
                vim.opt.colorcolumn = "0"
                vim.opt.cul = false
            end
        end
    },
    {
        {'BufLeave','FocusLost','InsertEnter'},
        function() 
            if (vim.bo.filetype ~= 'dashboard') then
                vim.opt.relativenumber = false 
            end
        end
    },
    {
        {'BufEnter','FocusGained','InsertLeave'},
        function() 
            if (vim.bo.filetype ~= 'dashboard') then
                vim.opt.relativenumber = true
            end
        end
    }
}

require('legendary').autocmds(autocmds)