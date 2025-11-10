return {
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
			vim.keymap.set("n", "<leader>m", vim.cmd.TSJToggle, { desc = "Toogle TSJ" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"json",
					"c",
					"lua",
					"luadoc",
					"fish",
					"bash",
					-- "dockerfile",
					"javascript",
					"typescript",
					"markdown",
					"markdown_inline",
					"gitignore",
					"css",
					"html",
					"vim",
					"vimdoc",
				},
				sync_install = false,
				ignore_install = {
					"dockerfile",
				},
				modules = {},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
