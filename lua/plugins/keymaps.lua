-- #################################################################
-- Keymaps that use a plugin. Required last in plugins/init.lua, so
-- every plugin is set up before its keymaps are defined.
-- Plain Neovim keymaps live in config/keymaps.lua
-- #################################################################

-- WINDOW & TMUX PANE NAVIGATION (vim-tmux-navigator)
-- NOTE: The plugin's default mappings are disabled in plugins/navigation.lua
vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { desc = "Go to left window/pane" })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { desc = "Go to lower window/pane" })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { desc = "Go to upper window/pane" })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { desc = "Go to right window/pane" })
vim.keymap.set("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", { desc = "Go to previous window/pane" })

-- OIL file explorer
-- NOTE: h (parent directory) and q (close) only exist in oil buffers, see plugins/navigation.lua
-- HELP: :help oil.open_float
vim.keymap.set("n", "<leader>e", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "Open oil in a float with preview" })

-- WHICH-KEY Helper
vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, {
	desc = "Buffer Local Keymaps (which-key)",
})

-- TELESCOPE fuzzy finder
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find recent files" })

-- LSP (telescope, conform, snacks)
-- NOTE: The plain LSP keymaps live in config/keymaps.lua. gr is nowait so it doesn't wait for
-- Neovim's default grr/gra/grn/gri/grt/grx, which share its prefix
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP go to definition" })
vim.keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "LSP go to type definition" })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { nowait = true, desc = "LSP references" })
vim.keymap.set("n", "gI", function()
	require("utils").lsp.goto_source_definition()
end, { desc = "LSP go to source definition or implementation" })
vim.keymap.set("n", ";c", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "LSP incoming calls" })
vim.keymap.set({ "n", "x" }, "<leader>lcf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format now" })
vim.keymap.set("n", "<leader>lcR", function()
	require("snacks").rename.rename_file()
end, { desc = "LSP rename file (updates imports)" })

-- GIT (gitsigns)
-- NOTE: <leader>gh stages the hunk under the cursor, and unstages it if it's already staged.
-- <leader>go and <leader>gs need more than one call, see lua/utils/git.lua
-- HELP: :help gitsigns
vim.keymap.set("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Git blame line" })
vim.keymap.set("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Git blame buffer" })
vim.keymap.set("n", "<leader>go", function()
	require("utils").git.open_line_commit()
end, { desc = "Git open file at the line's last commit" })
vim.keymap.set("n", "<leader>gs", function()
	require("utils").git.toggle_stage_buffer()
end, { desc = "Git stage or unstage buffer" })
vim.keymap.set("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Git stage or unstage hunk" })

-- GIT DIFF OVERLAY (mini.diff)
-- NOTE: In a diff window, ]c and [c keep their native job of jumping between changes
-- HELP: :help mini.diff, :help ]c
vim.keymap.set("n", "<leader>gd", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Git toggle diff overlay" })
local function goto_hunk(direction, native_key)
	return function()
		if vim.wo.diff then
			vim.cmd.normal({ vim.v.count1 .. native_key, bang = true })
		else
			require("mini.diff").goto_hunk(direction)
		end
	end
end
vim.keymap.set("n", "]c", goto_hunk("next", "]c"), { desc = "Next git hunk" })
vim.keymap.set("n", "[c", goto_hunk("prev", "[c"), { desc = "Previous git hunk" })

-- GIT DIFF VIEW (codediff)
-- NOTE: Under <leader>g, not <leader>d, so they don't clash with the no-copy delete operator.
-- Inside a CodeDiff tab <leader>gv closes it: an autocmd in config/autocmds.lua marks the tab
vim.keymap.set("n", "<leader>gv", function()
	vim.cmd(vim.t.codediff and "tabclose" or "CodeDiff")
end, { desc = "Git toggle diff view" })
vim.keymap.set("n", "<leader>gl", "<cmd>CodeDiff history %<CR>", { desc = "Git file history" })
vim.keymap.set("n", "<leader>gL", "<cmd>CodeDiff history<CR>", { desc = "Git repo history" })

-- LAZYGIT (snacks)
-- NOTE: Its `e` key comes back to this window, see the snacks setup in plugins/ui.lua
vim.keymap.set("n", ";g", function()
	require("utils").git.open_lazygit()
end, { desc = "Lazygit" })

-- TROUBLE diagnostics list
-- NOTE: The plain diagnostic toggles (<leader>td, <leader>tu) live in config/keymaps.lua
vim.keymap.set("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })

-- NOTIFICATIONS (snacks notifier)
-- NOTE: Dismissed popups stay in the history (<leader>nh)
-- HELP: https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
vim.keymap.set("n", "<leader>nd", function()
	require("snacks").notifier.hide()
end, { desc = "Dismiss notifications" })
vim.keymap.set("n", "<leader>nh", function()
	require("snacks").notifier.show_history()
end, { desc = "Notification history" })

-- WORD REFERENCES (snacks words)
-- NOTE: Jump between the highlighted references of the word under the cursor (needs a language
-- server). Global mappings: in Python and Markdown/Quarto buffers, their filetype plugins' own
-- ]] / [[ (next class/def, next heading) keep winning
-- HELP: https://github.com/folke/snacks.nvim/blob/main/docs/words.md
vim.keymap.set("n", "]]", function()
	require("snacks").words.jump(vim.v.count1)
end, { desc = "Next reference of the word" })
vim.keymap.set("n", "[[", function()
	require("snacks").words.jump(-vim.v.count1)
end, { desc = "Previous reference of the word" })

-- MARKDOWN / QUARTO (quarto-nvim, img-clip)
-- NOTE: The preview opens in the browser and also works for plain .md files
vim.keymap.set("n", "<leader>mp", "<Cmd>QuartoPreview<CR>", { desc = "Quarto preview in browser" })
vim.keymap.set("n", "<leader>mq", "<Cmd>QuartoClosePreview<CR>", { desc = "Close Quarto preview" })
vim.keymap.set("n", "<leader>mi", "<Cmd>PasteImage<CR>", { desc = "Paste clipboard image (img-clip)" })

-- RUN / REPL (vim-slime + quarto runner)
-- NOTE: Code goes to the REPL in the last active tmux pane (vim-slime, see utilities.lua). The
-- cell keymaps (rc/ra/rA) use quarto's runner and only work in .qmd files; line, paragraph and
-- selection go straight to slime and work in any file. <Plug> targets need remap = true
-- HELP: :help slime, https://github.com/quarto-dev/quarto-nvim
vim.keymap.set("n", "<leader>rc", function()
	require("quarto.runner").run_cell()
end, { desc = "Run cell (quarto)" })
vim.keymap.set("n", "<leader>ra", function()
	require("quarto.runner").run_above()
end, { desc = "Run cell and above (quarto)" })
vim.keymap.set("n", "<leader>rA", function()
	require("quarto.runner").run_all()
end, { desc = "Run all cells (quarto)" })
vim.keymap.set("n", "<leader>rl", "<Plug>SlimeLineSend", { remap = true, desc = "Send line to REPL" })
vim.keymap.set("n", "<leader>rp", "<Plug>SlimeParagraphSend", { remap = true, desc = "Send paragraph to REPL" })
vim.keymap.set("x", "<leader>rr", "<Plug>SlimeRegionSend", { remap = true, desc = "Send selection to REPL" })
vim.keymap.set("n", "<leader>rs", "<Plug>SlimeConfig", { remap = true, desc = "Set REPL target (tmux pane)" })
