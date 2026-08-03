return {
	-- Dashboard nvim
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- which key, for checking keys
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"yorickpeterse/nvim-window",
		keys = {
			{ "<leader>w", "<cmd>lua require('nvim-window').pick()<CR>", desc = "nvim-window Selection" },
		},
		config = function()
			require("nvim-window").setup({
				chars = { "1", "2", "3", "4", "5", "6", "7", "8" },
				normal_hl = "Normal",
				hint_hl = "Bold",
				border = "single",
			})
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				settings = {
					save_on_toggle = true,
				},
			})

			local function my_harpoon_add_file()
				harpoon:list():add()

				local f = vim.api.nvim_buf_get_name(0)
				vim.notify("Harpoon: <" .. f .. "> added", vim.log.levels.INFO, {})
			end

			local toggle_opts = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				ui_width_ratio = 0.375,
				title_pos = "center",
			}

			local function toggle_next_buffer()
				if harpoon:list():length() == 0 then
					vim.cmd("bnext")
				else
					harpoon:list():next({ ui_nav_wrap = true })
				end
			end

			local function toggle_prev_buffer()
				if harpoon:list():length() == 0 then
					vim.cmd("bprevious")
				else
					harpoon:list():prev({ ui_nav_wrap = true })
				end
			end

			vim.keymap.set("n", "Mm", my_harpoon_add_file)
			vim.keymap.set("n", "<leader>mm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
			end)
			vim.keymap.set("n", "M1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "M2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "M3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "M4", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "M5", function()
				harpoon:list():select(5)
			end)

			vim.keymap.set("n", "<Tab>", toggle_next_buffer)
			vim.keymap.set("n", "<S-Tab>", toggle_prev_buffer)
		end,
	},

	-- icons
	{ "nvim-tree/nvim-web-devicons" },

	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"html",
					"css",
					"bash",
					"tsx",
					"vim",
					"rust",
					"cpp",
					"c",
				},
				highlight = {
					enable = true,
				},
			})
		end,
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
	},

	-- rename?
	{
		"smjonas/inc-rename.nvim",
		enabled = false,
		config = true,
		keys = { { "<leader>rw", ":IncRename " } },
	},

	-- nvim surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- auto pairs / brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Refactoring tool
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	-- fidget
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {
			progress = {
				display = {
					progress_icon = { pattern = "moon" },
				},
			},
			notification = {
				window = {
					relative = "editor",
					winblend = 0,
					border = "none",
				},
			},
		},
		config = function(_, opts)
			local fidget = require("fidget")
			fidget.setup(opts)
			vim.notify = fidget.notify
		end,
	},

	-- neo-tree / file manager
	{
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal" },
		},
		opts = {
			filesystem = {
				window = {
					mappings = {
						["\\"] = "close_window",
					},
				},
			},
		},
	},

	-- nvim-telescope
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local builtin = require("telescope.builtin")
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local keymap = vim.keymap
			telescope.setup({
				defaults = {
					path_display = { "smart" },
					layout_strategy = "horizontal",
					disable_devicons = false,
					color_devicons = true,
					layout_config = { preview_cutoff = 100, width = 0.85 },
					prompt_prefix = "   ",
					selection_caret = " ",
					file_ignore_patterns = {
						"%.git/",
					},
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
						},
					},
				},
				pickers = {
					buffers = {
						sort_lastused = true,
						mappings = {
							i = {
								["<C-d>"] = "delete_buffer",
							},
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("fzf")

			keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Show old files" })
			keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Live grep" })
			keymap.set("n", "<leader>bu", builtin.buffers, { desc = "Show buffers" })

			keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			keymap.set("n", "<leader>man", builtin.man_pages, { desc = "Show builtin man-pages" })
			keymap.set("n", "<leader>com", builtin.commands, { desc = "Show vim builtin commands" })

			keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Show git files" })
			keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Show git status" })

			keymap.set("n", "<leader>cs", builtin.colorscheme, { desc = "Show available colorschemes" })
		end,
	},

	-- vimtex / latex
	{
		"lervag/vimtex",
		enabled = true,
		config = function()
			vim.cmd([[
            filetype plugin indent on
            syntax enable

            let g:vimtex_view_method = 'zathura'
            let g:vimtex_view_general_viewer = 'zathura'
            let g:vimtex_view_general_options = '--unique file:@pdf\src:@line@tex'
            let g:vimtex_compiler_method = 'latexmk'

            let g:vimtex_compiler_latexmk = {
                \ 'build_dir' : 'build',
                \}

            let g:vimtex_compiler_latexrun = {
                \ 'build_dir' : 'build',
                \}

            let g:vimtex_quickfix_ignore_filters = [
                \ 'Underfull',
                \ 'Overfull',
                \ 'Package subfig Warning',
                \ 'Package balance Warning',
                \]
            let g:polyglot_disabled=['tex']
            let maplocalleader = ","
            ]])
		end,
	},

	-- lualine harpoon
	{
		"kiennt63/harpoon-files.nvim",
		dependencies = {
			{ "ThePrimeagen/harpoon", branch = "harpoon2" },
		},
		opts = {
			max_length = 5,
			icon = "",
			show_icon = true,
			show_index = true,
			show_filename = true,
			separator_left = " ",
			separator_right = " ",
			reverse_order = false,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"kiennt63/harpoon-files.nvim",
		},
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status")
			local harpoon_files = require("harpoon_files")

			lualine.setup({
				options = {
					icons_enabled = true,
					globalstatus = false,
					theme = "auto",
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						"branch",
						{ "diff", colored = true },
						{
							"diagnostics",
							update_in_insert = true,
							symbols = { error = " " },
						},
					},
					lualine_c = { { "filename" }, { "searchcount" }, { harpoon_files.lualine_component } },
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e65" },
						},
						{
							function()
								local reg = vim.fn.reg_recording()
								if reg == "" then
									return ""
								end
								return "recording@" .. reg
							end,
						},
						"filetype",
						"fileformat",
					},
					lualine_y = {
						"progress",
					},
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", file_status = true, path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "neo-tree" },
			})
		end,
	},

	-- wilder for terminal cmd
	{
		"gelguy/wilder.nvim",
		config = function()
			local wilder = require("wilder")

			wilder.setup({
				modes = { ":", "/", "?" },
			})

			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
					highlighter = wilder.basic_highlighter(),
					left = { " ", wilder.popupmenu_devicons() },
					right = { " ", wilder.popupmenu_scrollbar() },
					max_height = "50%",
					min_height = "0",
					pumblend = 0,
					border = "rounded",
					prompt_position = "bottom",
					reverse = 0,
				}))
			)
		end,
	},

	-- diff view in nvim
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local keymap = vim.keymap
			keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
			keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
		end,
	},

	-- neo clip / clipboard manager
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = {
			{ "kkharji/sqlite.lua", module = "sqlite" },
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local keymap = vim.keymap
			require("neoclip").setup()
			require("telescope").load_extension("neoclip")
			keymap.set("n", "<leader>cc", "<cmd>Telescope neoclip<CR>", { desc = "open clipboard manager" })
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
				per_filetype = {
					["html"] = {
						enable_close = false,
					},
				},
			})
		end,
	},

	-- Markdown live preview
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"tree-sitter/tree-sitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("markview").setup({
				experimental = {
					check_rtp = false,
				},
				preview = {
					enable = false,
					modes = { "n", "no", "c" },
					hybrid_modes = {},
					callbacks = {
						on_enable = function(_, win)
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "c"
						end,
					},
				},
			})
		end,
	},

	-- indent blank line
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({
				scope = { highlight = highlight },
				exclude = {
					filetypes = {
						"dashboard",
					},
				},
			})
			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},

	-- type stats
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
}
