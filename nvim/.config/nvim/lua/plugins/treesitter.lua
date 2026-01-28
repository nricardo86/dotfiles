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
		version = false, -- Last release is way too old
		build = ":TSUpdateSync",
		event = { "BufReadPost", "BufNewFile" },
		lazy = false, -- Keep false to ensure loading for Neo-tree
		main = "nvim-treesitter.configs", -- Lazy handles the require logic here
		branch = "master", -- Explicitly force the stable branch
		opts = {
			ensure_installed = {
				"json",
				"c",
				"lua",
				"luadoc",
				"fish",
				"bash",
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
			ignore_install = {
				"dockerfile",
				"jsonc",
			},

			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = { enable = true },
		},
		-- Fallback config to handle edge cases
		config = function(_, opts)
			-- Protective call: If treesitter fails to load, don't crash neovim
			local status_ok, configs = pcall(require, "nvim-treesitter.configs")
			if not status_ok then
				return
			end
			configs.setup(opts)
		end,
	},
}
