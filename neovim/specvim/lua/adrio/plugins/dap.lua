return {}
-- return {
-- 	{
-- 		"mfussenegger/nvim-dap",
-- 		dependencies = {
-- 			"leoluz/nvim-dap-go",
-- 			"rcarriga/nvim-dap-ui",
-- 			"theHamsta/nvim-dap-virtual-text",
-- 			"nvim-neotest/nvim-nio",
-- 			"williamboman/mason.nvim",
-- 		},
-- 		config = function()
-- 			local dap = require("dap")
-- 			local ui = require("dapui")

-- 			-- Basic DAP UI setup
-- 			require("dapui").setup()
-- 			require("dap-go").setup()

-- 			-- Virtual text setup
-- 			require("nvim-dap-virtual-text").setup({
-- 				enabled = true,
-- 				enable_commands = true,
-- 				clear_on_continue = true,
-- 				highlight_changed_variables = true,
-- 				highlight_new_as_changed = false,
-- 				show_stop_reason = true,
-- 				commented = false,
-- 				only_first_definition = true,
-- 				all_references = false,
-- 				all_frames = false,
-- 				virt_text_pos = "eol",
-- 				virt_lines = false,
-- 				virt_lines_above = false,
-- 				filter_references_pattern = "<module",
-- 				text_prefix = " ",
-- 				separator = " ",
-- 				error_prefix = "🔴",
-- 				info_prefix = "🔵",
-- 				display_callback = function(variable)
-- 					local name = string.lower(variable.name)
-- 					local value = string.lower(variable.value)
-- 					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
-- 						return "*****"
-- 					end

-- 					if #variable.value > 15 then
-- 						return " " .. string.sub(variable.value, 1, 15) .. "... "
-- 					end

-- 					return " " .. variable.value
-- 				end,
-- 			})

-- 			-- Elixir configuration
-- 			local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
-- 			if elixir_ls_debugger ~= "" then
-- 				dap.adapters.mix_task = {
-- 					type = "executable",
-- 					command = elixir_ls_debugger,
-- 				}

-- 				dap.configurations.elixir = {
-- 					{
-- 						type = "mix_task",
-- 						name = "phoenix server",
-- 						task = "phx.server",
-- 						request = "launch",
-- 						projectDir = "${workspaceFolder}",
-- 						exitAfterTaskReturns = false,
-- 						debugAutoInterpretAllModules = false,
-- 					},
-- 				}
-- 			end

-- 			-- Add this section for debug line highlighting
-- 			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, bg = "#2ecc71" })

-- 			-- If you want the line number to also be highlighted, add this
-- 			vim.api.nvim_set_hl(0, "DapStoppedLinehl", { default = true, bg = "#27ae60" })

-- 			-- Update the DapStopped sign to use the new highlight groups
-- 			vim.fn.sign_define("DapStopped", {
-- 				text = "▶",
-- 				texthl = "DapStopped",
-- 				linehl = "DapStoppedLine",
-- 				numhl = "DapStoppedLinehl",
-- 			})

-- 			-- Signs configuration
-- 			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
-- 			vim.fn.sign_define(
-- 				"DapStopped",
-- 				{ text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
-- 			)
-- 			vim.fn.sign_define(
-- 				"DapBreakpointRejected",
-- 				{ text = "●", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
-- 			)
-- 			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
-- 			vim.fn.sign_define(
-- 				"DapBreakpointCondition",
-- 				{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
-- 			)

-- 			-- Global keymaps (available in all buffers)
-- 			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
-- 			vim.keymap.set("n", "<leader>dus", function()
-- 				local widgets = require("dap.ui.widgets")
-- 				local sidebar = widgets.sidebar(widgets.scopes)
-- 				sidebar.open()
-- 			end, { desc = "open sidebar" })

-- 			-- Function to set up Go-specific keymaps
-- 			local function setup_go_debug_mappings()
-- 				local bufnr = vim.api.nvim_get_current_buf()

-- 				-- Debug keymaps only for Go files
-- 				vim.keymap.set("n", "<leader>dgl", function()
-- 					require("dap-go").debug_test()
-- 				end, { buffer = bufnr, desc = "run go test under cursor" })

-- 				vim.keymap.set("n", "<F1>", dap.continue, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F2>", dap.step_into, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F3>", dap.step_over, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F4>", dap.step_out, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F5>", dap.step_back, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F13>", dap.restart, { buffer = bufnr })
-- 			end

-- 			-- Function to set up Elixir-specific keymaps
-- 			local function setup_elixir_debug_mappings()
-- 				local bufnr = vim.api.nvim_get_current_buf()

-- 				-- Debug keymaps only for Elixir files
-- 				vim.keymap.set("n", "<F1>", dap.continue, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F2>", dap.step_into, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F3>", dap.step_over, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F4>", dap.step_out, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F5>", dap.step_back, { buffer = bufnr })
-- 				vim.keymap.set("n", "<F13>", dap.restart, { buffer = bufnr })
-- 			end

-- 			-- Set up autocommands to configure debug mappings per filetype
-- 			vim.api.nvim_create_autocmd("FileType", {
-- 				pattern = "go",
-- 				callback = function()
-- 					setup_go_debug_mappings()
-- 				end,
-- 			})

-- 			vim.api.nvim_create_autocmd("FileType", {
-- 				pattern = "elixir",
-- 				callback = function()
-- 					setup_elixir_debug_mappings()
-- 				end,
-- 			})

-- 			-- DAP UI listeners
-- 			dap.listeners.before.attach.dapui_config = function()
-- 				ui.open()
-- 			end
-- 			dap.listeners.before.launch.dapui_config = function()
-- 				ui.open()
-- 			end
-- 			dap.listeners.before.event_terminated.dapui_config = function()
-- 				ui.close()
-- 			end
-- 			dap.listeners.before.event_exited.dapui_config = function()
-- 				ui.close()
-- 			end
-- 		end,
-- 	},
-- }
