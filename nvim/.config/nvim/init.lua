require("set")
require("map")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim"
	vim.fn.system({ "git", "clone", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
