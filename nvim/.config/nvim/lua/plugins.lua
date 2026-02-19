return {
	{
		"folke/which-key.nvim",
		opts = {
			preset = "helix",
			defaults = {},
			spec = {
				{
					mode = { "n", "x" },
					{ "<leader>b", group = "misc" },
					-- { "<leader>d", group = "debug" },
					{ "<leader>g", group = "Goto" },
					{ "<leader>h", group = "git" },
					{ "<leader>s", group = "search" },
					{ "<leader>t", group = "tabs" },
					-- { "<leader>v", group = "splits" },
				},
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			vim.keymap.set("n", "<A-n>", ":bn<CR>"),
			vim.keymap.set("n", "<A-p>", ":bp<CR>"),
			vim.keymap.set("n", "<A-i>", ":bd<CR>"),
		},
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
