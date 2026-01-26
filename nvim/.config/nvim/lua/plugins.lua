return {
	{ "tpope/vim-sleuth" },
	{ "neovim/nvim-lspconfig" },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {},
	},
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gf", vim.cmd.Git, { desc = "Vim[F]ugitive Git" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Gitsigns [P]review" }),
			vim.keymap.set(
				"n",
				"<leader>gb",
				":Gitsigns toggle_current_line_blame<CR>",
				{ desc = "Gitsigns Toogle [B]lame" }
			),
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			vim.keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Bufferline [n]ext" }),
			vim.keymap.set("n", "<leader>p", ":bp<CR>", { desc = "Bufferline [p]previous" }),
			vim.keymap.set("n", "<leader>x", ":bd<CR>", { desc = "Bufferline e[x]it" }),
		},
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })
		end,
	},
	{
		"junegunn/fzf",
	},
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
	{ "raimondi/delimitmate" },
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
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
	{ "christoomey/vim-tmux-navigator" },
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
}
