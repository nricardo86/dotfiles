return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		{
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", opts = {} },
		},
	},
	config = function()
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "smart_history")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "noice")
	end,
}
