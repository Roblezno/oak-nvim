-- #################################################################
-- Utility tools and Quality of Life related plugins. Configures:
-- nvim-autopairs, which-key, Trouble, img-clip, vim-slime
-- #################################################################

-- NVIM-AUTOPAIRS
require("nvim-autopairs").setup({
	event = "InsertENter",
	config = true,
})

-- WHICH-KEY
require("which-key").setup({})

-- TODO: Do I need this now?
-- TROUBLE
require("trouble").setup({})

-- IMG-CLIP.NVIM
-- NOTE: Pastes a clipboard image into an assets/ folder next to the current file and inserts the
-- markdown link. The defaults already cover markdown and quarto. Needs wl-clipboard on Wayland
-- (xclip on X11). The image popup on a link is snacks.image (see ui.lua)
-- HELP: https://github.com/HakonHarnes/img-clip.nvim, :checkhealth img-clip
require("img-clip").setup({
	default = {
		relative_to_current_file = true, -- assets/ next to the file, not in the cwd
	},
})

-- VIM-SLIME
-- NOTE: Sends code to a REPL (R, IPython, bash...) running in another tmux pane. "{last}" is the
-- last active pane, so open the REPL in a split next to nvim (<leader>rs picks another pane).
-- Quarto's code runner sends chunks through it (see markdown.lua). Bracketed paste keeps Python
-- indentation intact (needs IPython or Python 3.13+). slime_no_mappings must be set before the
-- plugin loads: its plugin/ files are only sourced after init.lua (see plugins/init.lua), so
-- setting it here is early enough. Keymaps live in plugins/keymaps.lua
-- HELP: https://github.com/jpalardy/vim-slime, :help slime
vim.g.slime_target = "tmux"
vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
vim.g.slime_dont_ask_default = 1 -- use the config above, no prompt on the first send
vim.g.slime_bracketed_paste = 1
vim.g.slime_no_mappings = 1 -- drop the default <C-c><C-c> and <C-c>v mappings
