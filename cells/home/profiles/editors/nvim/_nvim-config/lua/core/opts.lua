-- show file numbers
vim.opt.number = true
-- relative file numbers
vim.opt.relativenumber = true
vim.opt.nu = true
vim.opt.rnu = true

-- put numbers and signs in the same column
vim.opt.signcolumn = 'number'

-- >> editor <<--

-- shell

vim.opt.shell = "/run/current-system/sw/bin/bash"

-- set font in gui
if vim.opt.guifont then vim.opt.guifont = 'Fira Code' end

-- split a new buffer to the right
vim.opt.splitright = true
-- split new buffer to the bottom
vim.opt.splitbelow = true
-- briefly jump to matching seperator
vim.opt.showmatch = true
-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- highlight searches
vim.opt.hlsearch = true
-- copy-paste with system clipboard
vim.opt.clipboard = 'unnamedplus'
-- background color for themes
vim.opt.background = 'dark'
-- we support termguicolors
vim.opt.termguicolors = true
-- abandon buffer when unloading
vim.opt.hidden = true
-- some language servers dont like backup files
vim.opt.backup = false
vim.opt.writebackup = false
-- more space for coc messages
vim.opt.cmdheight = 3
-- more responsiveness
vim.opt.updatetime = 300
-- avoid some prompts?
vim.opt.shortmess:append({ c = true })
-- scrolling "bounding"
vim.opt.scrolloff = 7
vim.opt.sidescrolloff = 7

vim.opt.whichwrap:append({h=true,l=true})
vim.opt.foldcolumn = "2"
vim.opt.signcolumn = "yes"

vim.opt.lazyredraw = true
vim.opt.magic = true
vim.opt.showmatch = true
vim.opt.wildmode = "longest:list,full"
vim.opt.wildignore:append({"*/.git/*","*/.hg/*","*/.svn/*","*/.DS_Store"})
vim.opt.matchtime = 2
vim.opt.conceallevel = 1
-- >> buffer options <<--

vim.opt.tabstop = 8
-- implicit tab size
vim.opt.softtabstop = 4
-- another kind of stabstop
vim.opt.shiftwidth = 4
-- convert tabs to spaces
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.linebreak = true
vim.opt.textwidth = 500

-- set leader key to space
vim.g.mapleader = ' '
-- and also for the local buffer
-- because thats what `let` does...
vim.b.mapleader = ' '

vim.g.lasttab = 1

vim.opt.undofile = true

-- set language to english
vim.cmd('language en_US.utf-8')
-- vim.v.lang = 'en_US'

-- enable syntax highlighting
vim.cmd('syntax on')

-- enable filetype detection
vim.cmd('filetype plugin indent on')