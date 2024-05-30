return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "",
					package_pending = "",
					package_uninstalled = "",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			vim.cmd("MasonToolsUpdate")
		end,
		opts = {
			ensure_installed = {
				"tsserver",
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
				"markdown_oxide",
			},
		},
	},
}
