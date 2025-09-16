return {
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{
				"saecki/crates.nvim",
				tag = "stable",
				config = function()
					require("crates").setup()
				end,
			},
			{
				"mrcjkb/rustaceanvim",
				version = "^6", -- Recommended
				lazy = false, -- This plugin is already lazy
			},
		},
		config = function()
			-- │ GLOBALS │
			local lspconfig = require("lspconfig")

			-- │ LSP BORDER │
			require("lspconfig.ui.windows").default_options.border = "single"

			local lsp_attach = function(client, bufnr)
				local opts = { buffer = bufnr }
				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
				vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			end

			local border = {
				{ "┌", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "┐", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "┘", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "└", "FloatBorder" },
				{ "│", "FloatBorder" },
			}

			-- │ Diagnostics toggle (enable one function) │ --
			-- this will make diagnostics show constantly
			function enable_diagnostics_default()
				vim.diagnostic.config({
					virtual_text = true,
					signs = true,
					underline = true,
					update_in_insert = false,
					severity_sort = true,
					float = {
						focusable = false,
						style = "minimal",
						border = "rounded",
						source = "always",
						header = "",
						prefix = "",
					},
				})
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					callback = function()
						vim.diagnostic.open_float(nil, { focus = false })
					end,
				})
				vim.opt.updatetime = 250
			end

			-- this will make diagnostics on Keybinding
			function enable_toggle_diagnostics(keybinding)
				keybinding = keybinding or "E"
				vim.keymap.set("n", keybinding, function()
					-- If we find a floating window, close it.
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(win).relative ~= "" then
							vim.api.nvim_win_close(win, true)
							return
						end
					end
					vim.diagnostic.open_float(nil, { focus = false })
				end, { desc = "Toggle Diagnostics" })
			end

			enable_diagnostics_default()

			-- | Handlers | --
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
			}

			-- | Capabilities | --
			local global_capabilities = require("cmp_nvim_lsp").default_capabilities()

			--| C & C++ |
			vim.lsp.config("clangd", {
				handlers = handlers,
				capabilities = {
					offsetEncoding = "utf-16",
					global_capabilities,
				},
			})

			vim.lsp.enable("clangd")

			--| CSS |
			vim.lsp.config("cssls", {
				handlers = handlers,
				capabilities = global_capabilities,
			})
			vim.lsp.enable("cssls")

			--| JSON |
			vim.lsp.config("jsonls", {
				handlers = handlers,
				capabilities = global_capabilities,
			})
			vim.lsp.enable("jsonls")

			--| JAVA |
			vim.lsp.config("jdtls", {
				handlers = handlers,
				capabilities = global_capabilities,
			})
			vim.lsp.enable("jdtls")

			--| RUST |
			-- rust doesn't even need an init

			-- │ YAML SERVER │
			vim.lsp.config("yamlls", {
				handlers = handlers,
				settings = {
					yaml = {
						validate = true,
						hover = true,
						completion = true,
						format = {
							enable = true,
							singleQuote = true,
							bracketSpacing = true,
						},
						editor = {
							tabSize = 2,
						},
						schemaStore = {
							enable = true,
						},
					},
					editor = {
						tabSize = 2,
					},
				},
				capabilities = global_capabilities,
			})
			vim.lsp.enable("yamlls")

			-- vim.lsp.config('arduino_language_server'{
			-- 	--	on_attach = on_attach,
			-- 	--	capabilities = capabilities,
			-- 	handlers = handlers,
			-- 	-- init_options = {
			-- 	-- 	timeout = 10000, -- increase timeout to 10 seconds
			-- 	-- },
			-- 	cmd = {
			-- 		"$HOME/go/bin/arduino-language-server",
			-- 		"-cli-config",
			-- 		"$HOME/.arduino15/arduino-cli.yaml",
			-- 		"-fqbn",
			-- 		"arduino:avr:uno",
			-- 		"-cli",
			-- 		"$HOME/.local/bin/arduino-cli",
			-- 		"-clangd",
			-- 		"/usr/bin/clangd",
			-- 	},
			-- })
			-- vim.lsp.enable('arduino_language_server')
		end,
	},

	--  ╭─────────────╮
	--  │   MASON     │
	--  ╰─────────────╯
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	-- lsp saga
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = {
					enable = true,
					separator = " > ",
					show_file = true,
					delay = 400,
					color_mode = true,
				},
				outline = {
					layout = "float",
				},
				lightbulb = {
					enable = false,
					sign = false,
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}
