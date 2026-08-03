return {
	{
		"rafamadriz/friendly-snippets",
		lazy = true,
	},
	{
		"nvim-mini/mini.snippets",
		version = "*",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local gen_loader = require("mini.snippets").gen_loader
			require("mini.snippets").setup({
				snippets = {
					gen_loader.from_lang(),
				},
				mappings = {
					expand = "<C-j>",
					jump_next = "<C-l>",
					jump_prev = "<C-h>",
					stop = "<C-c>",
				},
			})
		end,
	},
	{
		"nvim-mini/mini.completion",
		version = "*",
		dependencies = { "nvim-mini/mini.snippets" },
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
					local item_selected = vim.fn.complete_info()["selected"] ~= -1
					return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
				end

				return keys["cr"]
			end

			vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
			require("mini.completion").setup({})
		end,
	},
}
