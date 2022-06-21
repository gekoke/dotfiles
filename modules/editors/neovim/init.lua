local vim = vim

vim.o.clipboard = "unnamedplus"
vim.o.relativenumber = true
vim.o.hlsearch = false
vim.o.hidden = true
vim.o.errorbells = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.nu = true
vim.o.wrap = false
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath("config") .. "/undo"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.showmode = false
vim.o.shortmess = "I"
vim.o.signcolumn = "yes"

vim.g.leader = " "

local colorscheme = "gruvbox"
vim.cmd("colorscheme " .. colorscheme)

