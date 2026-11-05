-- #################################################################
-- Visual interface related plugins. Configures:
-- solarized-osaka Theme, Alpha dashboard, Lualine, incline, tiny-cmdline,
-- todo-comments, snacks, smear-cursor, mini.icons, transparent-popups (disabled)
-- #################################################################

-- THEME
-- NOTE: solarized-osaka, vivid style (brighter text colors, higher contrast). Transparent
-- background, so the terminal's background (opacity, blur) shows through. Ghostty's built-in
-- "Solarized Osaka Night" theme uses the same palette. Floats and popup menus follow the
-- background through transparent-popups (below), when it is enabled
-- HELP: https://github.com/craftzdog/solarized-osaka.nvim
require("solarized-osaka").setup({
	transparent = true,
  --style = "vivid",
})

vim.cmd.colorscheme("solarized-osaka")

-- MINI.ICONS
-- NOTE: The one icon source for every plugin. The mock makes require("nvim-web-devicons") return
-- mini.icons, so plugins that only know devicons (telescope, lualine) use it too and
-- nvim-web-devicons is not installed. It must run before any of them asks for icons, so it stays
-- right after the colorscheme, at the top of the first group file (see plugins/init.lua)
-- HELP: :help mini.icons, :help MiniIcons.mock_nvim_web_devicons()
local mini_icons = require("mini.icons")
mini_icons.setup({})
mini_icons.mock_nvim_web_devicons()

-- SNACKS
-- NOTE: Only the modules enabled here run. Set up early (right after the icons), so notifications
-- from the other plugins' setup already go through its notifier
-- - notifier: replaces vim.notify, popups plus a history (<leader>nd/<leader>nh, plugins/keymaps.lua)
-- - indent: indent guides and the current scope
-- - statuscolumn: signs, line numbers and folds in the gutter
-- - words: highlights the word under the cursor everywhere (LSP document highlights, so it needs a
--   language server). ]] / [[ jump between them (plugins/keymaps.lua)
-- - image: with the cursor on an image link in .md/.qmd, shows the image in a popup (kitty
--   graphics protocol, ImageMagick converts non-PNG files). Inside tmux it needs
--   `allow-passthrough on` in ~/.tmux.conf. Pasting images is img-clip (utilities.lua)
-- - scroll: smooth scrolling stays off, scrolling should feel instant
-- Later steps turn on more modules (picker, lazygit)
-- HELP: https://github.com/folke/snacks.nvim, :checkhealth snacks
require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	image = {
		enabled = true,
		-- A popup at the cursor instead of drawing the images inline in the buffer
		doc = { inline = false, float = true },
	},
	scroll = { enabled = false },
})

-- TRANSPARENT POPUPS
-- NOTE: My own plugin: float borders and transparency that follow the colorscheme, padding for
-- LSP hover and the blink.cmp menu. Must stay after the colorscheme and before completion.lua
-- (blink.cmp uses it). pcall: if it isn't installed, keep the float border and load the rest
-- To turn it back on, uncomment its spec in plugins/init.lua and the block below
-- HELP: https://github.com/Roblezno/nvim-transparent-popups, :checkhealth transparent-popups
-- local has_transparent_popups, transparent_popups = pcall(require, "transparent-popups")
-- if has_transparent_popups then
-- 	transparent_popups.setup()
-- else
-- 	vim.o.winborder = "single"
-- 	vim.notify("transparent-popups not loaded: " .. transparent_popups:match("[^\n]+"), vim.log.levels.WARN)
-- end

-- ALPHA STARTING WINDOW
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	"▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌",
	"▐                                                                     ▌",
	"▐                                                                     ▌",
	"▐    ██████╗  █████╗ ██╗  ██╗     ███╗   ██╗██╗   ██╗██╗███╗   ███╗   ▌",
	"▐   ██╔═══██╗██╔══██╗██║ ██╔╝     ████╗  ██║██║   ██║██║████╗ ████║   ▌",
	"▐   ██║   ██║███████║█████╔╝█████╗██╔██╗ ██║██║   ██║██║██╔████╔██║   ▌",
	"▐   ██║   ██║██╔══██║██╔═██╗╚════╝██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║   ▌",
	"▐   ╚██████╔╝██║  ██║██║  ██╗     ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║   ▌",
	"▐    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   ▌",
	"▐                                                                     ▌",
	"▐                                                                     ▌",
	"▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌",
}

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", "<cmd>ene<CR>"),
	dashboard.button("SPC e", "󰙅  Oil"),
	dashboard.button("SPC ff", "󰈞  Find file"),
	dashboard.button("SPC fg", "󰈬  Find word"),
	dashboard.button("SPC fn", "  Nvim config"),
	dashboard.button("SPC fr", "󰋚  Find recent files"),
	dashboard.button("SPC wr", "󰁯  Restore last session"),
}

alpha.setup(dashboard.opts)

-- LUALINE
-- NOTE: One global bar. Sections: a mode | b git branch | c project root (only when it is not the
-- cwd), filetype icon, path | x macro recording, diagnostics, git diff | y progress | z line:col
-- The recording indicator stands in for the hidden command line (cmdheight 0)
-- HELP: :help lualine.txt
local root_markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

--- Name of the current file's project root (nearest folder upward with a root marker), shown
--- only when it differs from the cwd
---@return string
local function root_name()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" or vim.bo.buftype ~= "" then
		return ""
	end
	local root = vim.fs.root(path, root_markers)
	if not root or root == vim.fn.getcwd() then
		return ""
	end
	return "\u{f07c} " .. vim.fs.basename(root) -- Nerd Font folder-open icon
end

--- Path of the current file relative to the cwd (or ~), cut to its first part, "…" and the last 2
---@return string
local function pretty_path()
	if vim.bo.buftype == "terminal" then
		return "[Terminal]"
	end
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return "[No Name]"
	end
	local parts = vim.split(vim.fn.fnamemodify(path, ":~:."), "/", { plain = true })
	if #parts > 3 then
		parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
	end
	return (table.concat(parts, "/"):gsub("%%", "%%%%")) -- A literal % must be doubled
end

--- "recording @q" while a macro is being recorded, empty (hidden) otherwise
---@return string
local function recording()
	local reg = vim.fn.reg_recording()
	return reg == "" and "" or "recording @" .. reg
end

require("lualine").setup({
	options = {
		theme = "auto", -- The colorscheme's own lualine theme if it ships one, else built from it
		icons_enabled = true,
		-- One bar for all windows when 'laststatus' is 3 (set in config/options.lua). Without it
		-- lualine puts 'laststatus' back to 2
		globalstatus = vim.o.laststatus == 3,
		refresh = {
			-- lualine's default events (cursor moves included) plus macro start/stop
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			root_name,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			pretty_path,
		},
		lualine_x = { recording, "diagnostics", "diff" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- INCLINE
-- NOTE: A file name tag with its icon in the top-right corner of each window, plus [+] when
-- unsaved (like the tabline): with one global statusline, each split still says which file it
-- holds. The tag hides when the cursor reaches its line. The icon comes from mini.icons, in its
-- own color. Floats, unlisted and special buffers get no tag (incline's defaults)
-- HELP: :help incline, https://github.com/b0o/incline.nvim
require("incline").setup({
	hide = { cursorline = true },
	render = function(props)
		local unsaved = vim.bo[props.buf].modified and "[+] " or ""
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if name == "" then
			return { unsaved, "[No Name]" }
		end
		local icon, icon_hl = require("mini.icons").get("file", name)
		local icon_fg = vim.api.nvim_get_hl(0, { name = icon_hl, link = false }).fg
		return {
			unsaved,
			{ icon, guifg = icon_fg and ("#%06x"):format(icon_fg) },
			" ",
			name,
		}
	end,
})

-- TINY-CMDLINE
-- NOTE: Shows the `:` command line as a floating box on top of ui2 (enabled at the end of
-- config/options.lua), centered left to right and 20% from the top: with cmdheight 0 it needs
-- somewhere to appear, and near the top is where the eyes already are. Searches (/ ?) stay at the
-- bottom. The border follows 'winborder'. The blink adapter moves blink.cmp's cmdline menu along
-- with the box
-- HELP: https://github.com/rachartier/tiny-cmdline.nvim
local tiny_cmdline = require("tiny-cmdline")
tiny_cmdline.setup({
	position = { x = "50%", y = "20%" },
	on_reposition = tiny_cmdline.adapters.blink,
})

-- TODO COMMENTS
require("todo-comments").setup({})

-- SMEAR CURSOR
require("smear_cursor").setup({})
