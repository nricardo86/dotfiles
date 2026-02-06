return {
	{ "folke/which-key.nvim", event = "VeryLazy", opts = {}, keys = {} },
	{ "nmac427/guess-indent.nvim", event = { "BufReadPost", "BufNewFile" }, opts = {} },
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			vim.keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Bufferline [n]ext" }),
			vim.keymap.set("n", "<leader>p", ":bp<CR>", { desc = "Bufferline [p]revious" }),
			vim.keymap.set("n", "<leader>x", ":bd<CR>", { desc = "Bufferline e[x]it" }),
		},
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })
		end,
	},
	{ "junegunn/fzf" },
	{
		"stevearc/oil.nvim",
		opts = {
			columns = { "icon" },
			view_options = {
				show_hidden = true,
			},
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" }),
		},
	},
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({ create_mappings = false })
			vim.keymap.set({ "n", "v" }, "<leader>/", ":CommentToggle<CR>", { desc = "Toggle Comment" })
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" })
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{ "christoomey/vim-tmux-navigator" },
}
