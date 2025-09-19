local M = {
	{
		"nvim-mini/mini.completion",
		version = "*",
		config = function()
			local imap_expr = function(lhs, rhs)
				vim.keymap.set("i", lhs, rhs, { expr = true })
			end
			imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
			imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

			local keycode = vim.keycode
				or function(x)
					return vim.api.nvim_replace_termcodes(x, true, true, true)
				end
			local keys = {
				["cr"] = keycode("<CR>"),
				["ctrl-y"] = keycode("<C-y>"),
				["ctrl-y_cr"] = keycode("<C-y><CR>"),
			}

			_G.cr_action = function()
				if vim.fn.pumvisible() ~= 0 then
					-- If popup is visible, confirm selected item or add new line otherwise
					local item_selected = vim.fn.complete_info()["selected"] ~= -1
					return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
				else
					-- If popup is not visible, use plain `<CR>`. You might want to customize
					-- according to other plugins. For example, to use 'mini.pairs', replace
					-- next line with `return require('mini.pairs').cr()`
					return keys["cr"]
				end
			end

			vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
			require("mini.completion").setup({})
		end,
	},
}

return {
	-- LuaSnip snippet engine
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local luasnip = require("luasnip")

			-- Load friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")

			-- Basic LuaSnip configuration
			luasnip.config.setup({
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})
		end,
	},

	-- Friendly snippets collection
	{
		"rafamadriz/friendly-snippets",
		lazy = true, -- Only load when needed by LuaSnip
	},
	{
		"nvim-mini/mini.snippets",
		config = function()
			local gen_loader = require("mini.snippets").gen_loader
			require("mini.snippets").setup({
				snippets = {
					mappings = {
						expand = "<C-j>",
						jump_next = "<C-l>",
						jump_prev = "<C-h>",
						stop = "<C-c>",
					},
					gen_loader.from_lang(),
				},
			})
		end,
	},

	{
		"nvim-mini/mini.completion",
		version = "*",
		dependencies = { "L3MON4D3/LuaSnip" }, -- Add LuaSnip as dependency
		config = function()
			local luasnip = require("luasnip")

			local imap_expr = function(lhs, rhs)
				vim.keymap.set("i", lhs, rhs, { expr = true })
			end

			-- Updated Tab mapping to handle snippets
			imap_expr("<Tab>", function()
				if vim.fn.pumvisible() == 1 then
					return "<C-n>"
				elseif luasnip.expand_or_jumpable() then
					return "<cmd>lua require('luasnip').expand_or_jump()<CR>"
				else
					return "<Tab>"
				end
			end)

			-- Updated S-Tab mapping to handle snippets
			imap_expr("<S-Tab>", function()
				if vim.fn.pumvisible() == 1 then
					return "<C-p>"
				elseif luasnip.jumpable(-1) then
					return "<cmd>lua require('luasnip').jump(-1)<CR>"
				else
					return "<S-Tab>"
				end
			end)

			local keycode = vim.keycode
				or function(x)
					return vim.api.nvim_replace_termcodes(x, true, true, true)
				end
			local keys = {
				["cr"] = keycode("<CR>"),
				["ctrl-y"] = keycode("<C-y>"),
				["ctrl-y_cr"] = keycode("<C-y><CR>"),
			}
			_G.cr_action = function()
				if vim.fn.pumvisible() ~= 0 then
					-- If popup is visible, confirm selected item or add new line otherwise
					local item_selected = vim.fn.complete_info()["selected"] ~= -1
					return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
				else
					-- If popup is not visible, use plain `<CR>`. You might want to customize
					-- according to other plugins. For example, to use 'mini.pairs', replace
					-- next line with `return require('mini.pairs').cr()`
					return keys["cr"]
				end
			end
			vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
			require("mini.completion").setup({})
		end,
	},
}
