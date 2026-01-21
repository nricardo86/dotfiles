vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.editorconfig = true
vim.scriptencoding = "utf-8"
vim.encoding = "utf-8"
vim.fileencoding = "utf-8"

vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.showmode = false

vim.opt.ignorecase = true
vim.opt.autoindent = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.clipboard = "unnamedplus"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = "split"
vim.opt.cursorline = true

vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
