return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			bash = { "shfmt" },
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 500,
		},
		-- vim.keymap.set("n", "<leader>f", function()
		-- 	require("conform").format({ async = true, lsp_fallback = true })
		-- end, { desc = "Trigger [F]ormat" }),
	},
}
