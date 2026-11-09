-- #################################################################
-- Navigation related plugins. Configures:
-- Oil, Scrollbar, Telescope, Tmux-navigation
-- #################################################################

-- OIL file explorer
-- NOTE: Replaces netrw (default_file_explorer is on by default). Directories are buffers: rename,
-- move and delete by editing the text, then :w. h and q are set here because oil binds them on its
-- own buffers. <leader>e, which opens it, is in plugins/keymaps.lua
-- HELP: :help oil, https://github.com/stevearc/oil.nvim

-- Files oil won't preview: snacks.image would draw them in the terminal, which glitches the UI
local no_preview_exts = {
	"png",
	"jpg",
	"jpeg",
	"gif",
	"bmp",
	"webp",
	"tiff",
	"heic",
	"avif",
	"icns",
	"pdf",
	"mp4",
	"mov",
	"avi",
	"mkv",
	"webm",
}

require("oil").setup({
	columns = { "icon", "permissions", "size", "mtime" },
	-- Renaming a file asks the language server to update imports, and those edits are saved
	lsp_file_methods = { autosave_changes = true },
	keymaps = {
		["h"] = { "actions.parent", mode = "n" },
		["q"] = { "actions.close", mode = "n" },
	},
	view_options = { show_hidden = true },
	float = { max_width = 200, border = "rounded" },
	preview_win = {
		disable_preview = function(filename)
			return vim.list_contains(no_preview_exts, vim.fn.fnamemodify(filename, ":e"):lower())
		end,
	},
})

-- SCROLLBAR
require("scrollbar").setup({})

-- TELESCOPE
-- NOTE: fzf is the native sorter, built by the PackChanged hook in config/autocmds.lua
require("telescope").setup({})
require("telescope").load_extension("fzf")

-- TMUX NAVIGATOR
-- Disable plugin default mappings, they are defined in plugins/keymaps.lua
-- NOTE: Read when the plugin loads, after init.lua, so setting it here is early enough
-- (see plugins/init.lua)
vim.g.tmux_navigator_no_mappings = 1
