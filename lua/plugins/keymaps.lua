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

-- NEOTREE file explorer
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {
	desc = "Toggle Neo-tree",
	silent = true,
})

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

-- TROUBLE diagnostics list
-- NOTE: The plain diagnostic toggles (<leader>td, <leader>tu) live in config/keymaps.lua
vim.keymap.set("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })

-- NOTIFY (nvim-notify)
-- NOTE: Dismissed popups stay in the history (<leader>nh)
-- HELP: :help notify.dismiss(), :Notifications
vim.keymap.set("n", "<leader>nd", function()
	require("notify").dismiss({ silent = true, pending = true })
end, { desc = "Dismiss notifications" })
vim.keymap.set("n", "<leader>nh", "<Cmd>Notifications<CR>", { desc = "Notification history" })

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
