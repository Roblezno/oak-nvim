-- =========================================================================
-- TITLE: NeoVim Keymaps
-- ABOUT: Native editor-wide mappings; keymaps that use a plugin live in plugins/keymaps.lua
-- HELP: :help vim.lsp.buf.format(), :help vim.ui.select(), :help package-undotree
-- ============================================================================

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Registers: delete, change and paste without touching the yank register, so the yanked text
-- stays safe while editing around it. <leader>p pastes the last yank (register 0), even after
-- deleting something. dw deletes the word backwards, also without copying
-- HELP: :help quote_, :help quote0
vim.keymap.set("n", "x", '"_x', { desc = "Delete character (no copy)" })
vim.keymap.set({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete (no copy)" })
vim.keymap.set({ "n", "x" }, "<leader>c", '"_c', { desc = "Change (no copy)" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"0p', { desc = "Paste last yank" })
vim.keymap.set("n", "dw", 'vb"_d', { desc = "Delete word backwards (no copy)" })

-- Numbers and selection
-- NOTE: + and - take over increment/decrement, so <C-a> is free for select all
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })
-- vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Open a line below/above without continuing the comment (keeps the indentation)
vim.keymap.set("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below (no comment)" })
vim.keymap.set("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above (no comment)" })

-- Tabs
-- NOTE: te leaves `:tabedit ` in the command line: Enter opens an empty tab, or type a file first
vim.keymap.set("n", "te", ":tabedit ", { desc = "New tab" })

-- Splitting & Resizing
-- NOTE: Moving between windows/tmux panes (<C-h/j/k/l>) uses vim-tmux-navigator, see plugins/keymaps.lua
vim.keymap.set("n", "ss", "<Cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "sv", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- LSP remaps (originaly g<t,r,a,i...>)
vim.keymap.set({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, { desc = "LSP format buffer" })
vim.keymap.set({ "n", "v" }, "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "LSP action" })
vim.keymap.set({ "n", "v" }, "<leader>li", vim.lsp.buf.implementation, { desc = "LSP go to implementation" })
vim.keymap.set({ "n", "v" }, "<leader>lR", vim.lsp.buf.references, { desc = "LSP references" })
vim.keymap.set({ "n", "v" }, "<leader>lt", vim.lsp.buf.type_definition, { desc = "LSP type deffinition" })

-- Diagnostics with T (the Trouble list, <leader>tx, is in plugins/keymaps.lua)
-- Toggle diagnostics globally. <leader>tu keeps the gutter signs and only hides underlines
-- HELP: :help vim.diagnostic.enable(), :help vim.diagnostic.config()
vim.keymap.set("n", "<leader>td", function()
	local enabled = not vim.diagnostic.is_enabled()
	vim.diagnostic.enable(enabled)
	vim.notify("Diagnostics " .. (enabled and "on" or "off"))
end, { desc = "Toggle diagnostics (all)" })
vim.keymap.set("n", "<leader>tu", function()
	local underline = not vim.diagnostic.config().underline
	vim.diagnostic.config({ underline = underline })
	vim.notify("Diagnostic underlines " .. (underline and "on" or "off"))
end, { desc = "Toggle diagnostic underlines (keep signs)" })
