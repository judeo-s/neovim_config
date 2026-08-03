return {
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
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

			-- | inlay Hints |
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("inlay-hintsAttach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.inlayHintProvider then
						vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#d8d8d8", bg = "#3a3a3a" })
						vim.api.nvim_create_autocmd("InsertEnter", {
							buffer = event.buf,
							callback = function()
								vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
							end,
						})
						vim.api.nvim_create_autocmd({ "InsertLeave", "LspNotify" }, {
							buffer = event.buf,
							callback = function()
								vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
							end,
						})
					end
				end,
			})

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
			local function enable_diagnostics_default()
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
			local function enable_toggle_diagnostics(keybinding)
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
			local function float_config(config)
				return vim.tbl_deep_extend("force", config or {}, { border = border })
			end

			local function hover_handler(_, result, ctx, config)
				config = float_config(config)
				config.focus_id = ctx.method

				if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
					return
				end

				if not (result and result.contents) then
					if config.silent ~= true then
						vim.notify("No information available")
					end
					return
				end

				local contents
				if type(result.contents) == "table" and result.contents.kind == "plaintext" then
					contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
				else
					contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
				end

				if vim.tbl_isempty(contents) then
					if config.silent ~= true then
						vim.notify("No information available")
					end
					return
				end

				return vim.lsp.util.open_floating_preview(contents, "plaintext", config)
			end

			local sig_help_ns = vim.api.nvim_create_namespace("nvim.lsp.signature_help")

			local function signature_handler(_, result, ctx, config)
				config = float_config(config)
				config.focus_id = ctx.method

				if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
					return
				end

				if not (result and result.signatures and result.signatures[1]) then
					if config.silent ~= true then
						print("No signature help available")
					end
					return
				end

				local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
				local triggers = vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
				local ft = vim.bo[ctx.bufnr].filetype
				local lines, hl = vim.lsp.util.convert_signature_help_to_markdown_lines(result, ft, triggers)

				if not lines or vim.tbl_isempty(lines) then
					if config.silent ~= true then
						print("No signature help available")
					end
					return
				end

				local fbuf, fwin = vim.lsp.util.open_floating_preview(lines, "plaintext", config)
				if hl then
					vim.hl.range(fbuf, sig_help_ns, "LspSignatureActiveParameter", { hl[1], hl[2] }, { hl[3], hl[4] })
				end

				return fbuf, fwin
			end

			local handlers = {
				["textDocument/hover"] = hover_handler,
				["textDocument/signatureHelp"] = signature_handler,
			}

			vim.lsp.handlers["textDocument/hover"] = hover_handler
			vim.lsp.handlers["textDocument/signatureHelp"] = signature_handler

			-- | Capabilities | --
			local global_capabilities = vim.lsp.protocol.make_client_capabilities()
			global_capabilities.textDocument.completion.completionItem.snippetSupport = true
			global_capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			}

			--| C & C++ |
			vim.lsp.config("clangd", {
				handlers = handlers,
				capabilities = vim.tbl_deep_extend("force", {}, global_capabilities, {
					offsetEncoding = { "utf-16" },
				}),
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

			--| CMAKE |
			vim.lsp.config("neocmake", {
				handlers = handlers,
				capabilities = global_capabilities,
				init_options = {
					format = { enable = true },
					lint = { enable = true },
				},
			})
			vim.lsp.enable("neocmake")

			--| JAVA |
			--| JAVA |

			local root_markers = vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })
			local root_dir = root_markers[1] and vim.fs.dirname(root_markers[1]) or vim.fn.getcwd()
			local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
			local workspace_dir = vim.fn.expand("~/.cache/jdtls/workspace/" .. project_name)

			-- Ensure workspace directory exists
			vim.fn.mkdir(workspace_dir, "p")

			-- Define capabilities with proper client command support
			local java_capabilities = vim.tbl_deep_extend("force", {}, global_capabilities, {
				workspace = {
					executeCommand = {
						dynamicRegistration = false,
					},
					workspaceEdit = {
						documentChanges = true,
						resourceOperations = { "create", "rename", "delete" },
					},
				},
			})

			-- Custom handlers to fix the missing command issues
			local java_handlers = {
				["workspace/executeClientCommand"] = function(_, result, ctx)
					-- Handle client commands that JDTLS tries to execute
					if result and result.command then
						if result.command == "_java.reloadBundles.command" then
							-- This is usually safe to ignore or we can trigger a workspace reload
							vim.schedule(function()
								vim.lsp.buf_request(0, "workspace/executeCommand", {
									command = "java.clean.workspace",
								})
							end)
							return { applied = true }
						end
					end
					return nil
				end,

				["language/status"] = function(_, result)
					-- Handle status updates from JDTLS
					if result and result.message then
						-- Only show important status messages
						if result.type == "Started" or result.type == "Error" then
							vim.notify("JDTLS: " .. result.message, vim.log.levels.INFO)
						end
					end
				end,
			}

			vim.lsp.config("jdtls", {
				handlers = vim.tbl_extend("force", handlers, java_handlers),
				capabilities = java_capabilities,
				settings = {
					java = {
						eclipse = {
							downloadSources = true,
						},
						configuration = {
							updateBuildConfiguration = "interactive",
							runtimes = {
								-- Add your Java runtime configurations here if needed
								-- {
								--     name = "JavaSE-11",
								--     path = "/usr/lib/jvm/java-11-openjdk/",
								-- },
							},
						},
						maven = {
							downloadSources = true,
						},
						implementationsCodeLens = {
							enabled = true,
						},
						referencesCodeLens = {
							enabled = true,
						},
						references = {
							includeDecompiledSources = true,
						},
						format = {
							enabled = true,
						},
						saveActions = {
							organizeImports = true,
						},
						completion = {
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
							},
						},
					},
				},
				cmd = {
					"jdtls",
					"-data",
					workspace_dir,
					"-configuration",
					vim.fn.expand("~/.cache/jdtls/config"),
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
				},
				root_dir = root_dir,
				-- Add initialization options
				init_options = {
					bundles = {},
					workspaceFolders = vim.NIL,
					settings = {
						java = {
							signatureHelp = { enabled = true },
							contentProvider = { preferred = "fernflower" },
							completion = {
								favoriteStaticMembers = {
									"org.hamcrest.MatcherAssert.assertThat",
									"org.hamcrest.Matchers.*",
									"org.hamcrest.CoreMatchers.*",
									"org.junit.jupiter.api.Assertions.*",
									"java.util.Objects.requireNonNull",
									"java.util.Objects.requireNonNullElse",
								},
							},
						},
					},
				},
				-- Add flags to reduce some of the warnings
				flags = {
					allow_incremental_sync = true,
					debounce_text_changes = 80,
				},
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
