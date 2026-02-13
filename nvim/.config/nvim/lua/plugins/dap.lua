return {
	{ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } },
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},

	config = function()
		require("nvim-dap-virtual-text").setup({})
		local dap = require("dap")

		dap.configurations.c = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				args = {}, -- provide arguments if needed
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
			{
				name = "Select and attach to process",
				type = "gdb",
				request = "attach",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				pid = function()
					local name = vim.fn.input("Executable name (filter): ")
					return require("dap.utils").pick_process({ filter = name })
				end,
				cwd = "${workspaceFolder}",
			},
			{
				name = "Attach to gdbserver :1234",
				type = "gdb",
				request = "attach",
				target = "localhost:1234",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
			},
		}

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
