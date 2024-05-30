return {
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { char = "┃" },
			})
		end,
	},
}
