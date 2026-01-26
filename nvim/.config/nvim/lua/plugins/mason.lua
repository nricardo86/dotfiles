return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "",
					package_pending = "",
					package_uninstalle = "",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				-- "ts_ls",
				"prettier",
				"clangd",
				"eslint-lsp",
				"clang-format",
				"lua_ls",
				"stylua",
				"luacheck",
				"html",
				"cssls",
				"jsonls",
				"bashls",
				"shfmt",
			},
		},
	},
}
