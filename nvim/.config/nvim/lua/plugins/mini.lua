return {
	{ "nvim-mini/mini.sessions", lazy = true, opts = {} },
	{ "nvim-mini/mini.ai", opts = {
		n_lines = 500,
	} },
	-- { "nvim-mini/mini.icons", lazy = true, opts = {} },
	{
		"nvim-mini/mini.surround",
		opts = {},
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"nvim-mini/mini.pairs",
		event = "VeryLazy",
		opts = {
			mappings = {
				["<"] = { action = "open", pair = "<>", neigh_pattern = "^[^\\]" },
			},
		},
	},
	{
		"nvim-mini/mini.nvim",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
}
