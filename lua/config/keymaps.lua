local keymap = vim.keymap -- for conciseness

-- Set leader key
vim.g.mapleader = " "

-- Toggle line numbers
keymap.set("n", "<leader>n", ":set invnumber invrelativenumber<CR>")

-- Disable the arrow keys
keymap.set("n", "<Left>", ":echo 'use h twat'<CR>")
keymap.set("n", "<Right>", ":echo 'use l twat'<CR>")
keymap.set("n", "<Up>", ":echo 'use k twat'<CR>")
keymap.set("n", "<Down>", ":echo 'use j twat'<CR>")
keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- some line movement
keymap.set("n", "H", "^")
keymap.set("n", "L", "$")

-- Split window
keymap.set("n", "se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { desc = "Make vertical split", silent = true })
keymap.set("n", "ss", ":split<Return>", { desc = "Make horizontal split", silent = true })

-- Move to window
keymap.set("n", "sh", "<C-w>h", { desc = "Move window left" })
keymap.set("n", "sk", "<C-w>k", { desc = "Move window up" })
keymap.set("n", "sj", "<C-w>j", { desc = "Move window down" })
keymap.set("n", "sl", "<C-w>l", { desc = "Move window right" })

-- tab management
keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab

--  Lazy UI and Mason UI
keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy UI" })
keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason UI" })

-- Paste replace visual selection without copying it
keymap.set("v", "p", '"_dP')

-- Set jk to esc
keymap.set("i", "jk", "<ESC>")

--  Resizing windows
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Do not yank when x is pressed
keymap.set("n", "x", '"_x')

-- Render markdown using Markdown preview
keymap.set("n", "<leader>md", "<cmd>Markview toggle<CR>", { desc = "Toggle markdown preview" })

-- Move lines up and down
keymap.set("n", "<A-j>", ":move .+1<CR>==")
keymap.set("n", "<A-k>", ":move .-2<CR>==")
keymap.set("v", "<A-k>", ":move '<-2<CR>gv=gv")
keymap.set("v", "<A-j>", ":move '>+1<CR>gv=gv")

-- Run the current line as a shell command, replace with the output
keymap.set("n", "Q", "!!zsh<CR>")
