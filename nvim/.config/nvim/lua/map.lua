vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "x", [["_x]])

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "[p]aste over selection" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[y]ank selection" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank line" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[d]elete to blackhole" })

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [d]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [d]iagnostic message" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show Diagnostic [e]rror messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open Diagnostic [q]uickfix list" })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "[o]pen new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to [n]ext tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to [p]revious tab" })
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew %<CR>", { desc = "Open curren[t] buffer in new tab" })

vim.keymap.set("n", "<leader>vv", "<C-w>v", { desc = "Split window [v]ertically" })
vim.keymap.set("n", "<leader>vh", "<C-w>s", { desc = "Split window [h]orizontally" })
vim.keymap.set("n", "<leader>ve", "<C-w>=", { desc = "Make splits [e]qual size" })
vim.keymap.set("n", "<leader>vx", "<cmd>close<CR>", { desc = "Close current split" })

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "[q]uit" })
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>", { desc = "[Q]uit without saving" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "[w]rite current buffer" })

vim.keymap.set("n", "<leader>bs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
	desc = "[s]ubstitute hover word",
})

vim.keymap.set("n", "<leader>bx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file e[x]ecutable" })

vim.keymap.set("n", "<leader>,", function()
	vim.cmd("so")
end, { desc = "Source current buffer" })
