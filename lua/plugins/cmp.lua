return {
    
	{ "nvim-mini/mini.completion",
        version = "*",
        config = function()
            require('mini.completion').setup()
        end
    },

	--[[
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				run = "make install_jsregexp",
			},
            { 'crazyhulk/cmp-sign'},
            -- other cmp focused
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "FelipeLema/cmp-async-path" },
			{ "Snikimonkd/cmp-go-pkgs" },
			{ "David-Kunz/cmp-npm" },
			{ "SergioRibera/cmp-dotenv" },
			{ "saecki/crates.nvim", tag = "stable" },
		},
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")

			cmp.setup({
                snippet = {
                expand = function (args)
                     require('luasnip').lsp_expand(args.body)
                end
                },
				-- ... Your other configuration ...
				mapping = {
					-- ... Your other mappings ...
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Ctrl+Space to trigger completion menu
					["<C-Space>"] = cmp.mapping.complete(),

					-- Navigate between snippet placeholder
					["<C-f>"] = cmp.mapping.luasnip_jump_forward(),
					["<C-b>"] = cmp.mapping.luasnip_jump_backward(),

					-- Scroll up and down in the completion documentation
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
                    { name = 'nvim_cmp_sign' },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "async_path" },
					{ name = "npm", keyword_length = 4 },
					{ name = "crates" },
					{ name = "go_pkgs" },
					{ name = "dotenv" },
					{
						{ name = "buffer" },
					},
				}),
			})
		end,
	},
	--[[
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				run = "make install_jsregexp",
			},
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "FelipeLema/cmp-async-path" },
			{ "Snikimonkd/cmp-go-pkgs" },
			{ "David-Kunz/cmp-npm" },
			{ "SergioRibera/cmp-dotenv" },
			{ "saecki/crates.nvim", tag = "stable" },
		},
		config = function()
			local cmp = require("cmp")
			local cmp_npm = require("cmp-npm")
			local cmp_crates = require("crates")

			-- set up npm completion
			cmp_npm.setup({})
			cmp_crates.setup({})

			-- set up completion
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				preselect = "item",
				mapping = cmp.mapping.preset.insert({
					-- `Enter` key to confirm completion
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- tab to select
					["<Tab>"] = cmp.mapping.luasnip_supertab(),
					["<S-Tab>"] = cmp.mapping.luasnip_shift_supertab(),

					-- Ctrl+Space to trigger completion menu
					["<C-Space>"] = cmp.mapping.complete(),

					-- Navigate between snippet placeholder
					["<C-f>"] = cmp.mapping.luasnip_jump_forward(),
					["<C-b>"] = cmp.mapping.luasnip_jump_backward(),

					-- Scroll up and down in the completion documentation
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
				}),

				formatting = {
					fields = { "menu", "abbr", "kind" },

					format = function(entry, item)
						local menu_icon = {
							nvim_lsp = "λ",
							luasnip = "⋗",
							buffer = "Ω",
							path = "🖫",
							nvim_lua = "Π",
						}

						item.menu = menu_icon[entry.source.name]

						return item
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				sources = cmp.config.sources({
                    { name = 'nvim_cmp_sign' }
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "async_path" },
					{ name = "npm", keyword_length = 4 },
					{ name = "crates" },
					{ name = "go_pkgs" },
					{ name = "dotenv" },
					{
						{ name = "buffer" },
					},
				}),
			})
		end,
	},
    ]]
}
