return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
		require("which-key").setup({})
		require("which-key").register({
			["<leader>b"] = { name = "[b] side", _ = "which_key_ignore" },
			["<leader>d"] = { name = "[D]iagnostics", _ = "which_key_ignore" },
			["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
			["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
			["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
			["<leader>t"] = { name = "[T]abs", _ = "which_key_ignore" },
			["<leader>v"] = { name = "Splits", _ = "which_key_ignore" },
		})
	end,
}
