



return {
	-- colorscheme : catppuccin
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	-- colorscheme : horizon
	{
		"akinsho/horizon.nvim",
		version = "*",
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("horizon")
		end,
	},
	-- colorscheme : sonokai
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.sonokai_style = "espresso"
			vim.g.sonokai_better_performance = 1
			vim.g.sonokai_enable_italic = true
			-- vim.cmd.colorscheme("sonokai")
		end,
	},
	-- colorscheme : gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			--	vim.cmd.colorscheme("gruvbox")
		end,
	},

	-- colorscheme : nightfly
	{
		"bluz71/vim-nightfly-guicolors",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- vim.cmd.colorscheme("nightfly")
		end,
	},

	-- colorscheme : onedark
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		config = function()
			vim.cmd.colorscheme("onedark_dark")
		end,
	},

	-- colorscheme : synthwave84
	{
		"lunarvim/synthwave84.nvim",
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("synthwave84")
		end,
	},
	-- colorscheme : Kanagawa
	{
		"rebelot/kanagawa.nvim",
		config = function()
			--vim.cmd.colorscheme("kanagawa-dragon")
		end,
	},

}
