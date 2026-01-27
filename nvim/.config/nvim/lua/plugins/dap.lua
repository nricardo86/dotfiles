return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},

	config = function()
		require("nvim-dap-virtual-text").setup({})
		local dap = require("dap")

		--dap.adapters["pwa-node"] = {
		--type = "server",
		--host = "localhost",
		--port = 8123,
		--executable = {
		--command = "js-debug-adapter",
		--},
		--}

		--for _, language in ipairs({ "typescript", "javascript" }) do
		--dap.configurations[language] = {
		--{
		--type = "pwa-node",
		--request = "launch",
		--name = "Launch file",
		--program = "${file}",
		--cwd = "${workspaceFolder}",
		--runtimeExecutable = "node",
		--},
		--{
		--type = "pwa-node",
		--request = "attach",
		--name = "Attach",
		--processId = require("dap.utils").pick_process,
		--cwd = "${workspaceFolder}",
		--},
		--}
		--end

		-- dap-ui
		local dapui = require("dapui")
		dapui.setup()
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.after.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.after.event_exited["dapui_config"] = function()
			dapui.close()
		end

		vim.keymap.set("n", "<F1>", dap.toggle_breakpoint, { desc = "Dap Toogle Breakpoint" })
		vim.keymap.set("n", "<F2>", dap.continue, { desc = "Dap Run/Continue" })
		vim.keymap.set("n", "<F3>", dap.step_into, { desc = "Dap StepInto" })
		vim.keymap.set("n", "<F4>", dap.step_over, { desc = "Dap StepOver" })
		vim.keymap.set("n", "<F5>", dap.step_out, { desc = "Dap StepOut" })
		vim.keymap.set("n", "<F10>", dap.terminate, { desc = "Dap Terminate" })
	end,
}
