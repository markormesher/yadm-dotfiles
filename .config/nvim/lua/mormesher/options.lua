require("mormesher/globals")

vim.g.mapleader = ","

local opt = vim.opt

-- no mouse
opt.mouse = nil

-- keep undo history even after exiting
opt.undofile = true

-- dont re-draw during macros
opt.lazyredraw = true

-- highlight changes/replacements using `s` as they're typed (neovim only)
opt.inccommand = "nosplit"

-- make searches without caps case-insensitive
opt.smartcase = true
opt.ignorecase = true

-- some servers have issues with backup files
opt.backup = false
opt.writebackup = false

-- default tab size of 2 spaces (may be overwritten by vim-sleuth)
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- hide buffers when abandoned
opt.hidden = true

-- better colour support
opt.termguicolors = true

-- show current line number and relative numbers on other lines
opt.number = true
opt.relativenumber = true

-- always show the sign column to avoid janky changes when signs appear/disappear
opt.signcolumn = "yes"

-- keep the cursor X lines away from the top and bottom of the window (except for the start and end of files)
opt.scrolloff = 10

-- more space for messages
-- TODO: can I make this zero?
opt.cmdheight = 2

-- don't pass messages to |ins-completion-menu|.
opt.shortmess:append "c"
