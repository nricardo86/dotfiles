return {
	"ThePrimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add current buffer to Harpoon" })
		vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu, { desc = "display harpoon list" })

		vim.keymap.set("n", "<C-q>", function()
			ui.nav_file(1)
		end)
		vim.keymap.set("n", "<C-w>", function()
			ui.nav_file(2)
		end)
		vim.keymap.set("n", "<C-e>", function()
			ui.nav_file(3)
		end)
		vim.keymap.set("n", "<C-r>", function()
			ui.nav_file(4)
		end)
	end,
}