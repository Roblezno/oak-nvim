-- #################################################################
-- Visual interface related plugins. Configures:
-- solarized-osaka Theme, Alpha dashboard, Lualine, tiny-cmdline, todo-comments,
-- Notify, smear-cursor, mini.icons, transparent-popups (disabled)
-- #################################################################

-- THEME
-- NOTE: solarized-osaka, vivid style (brighter text colors, higher contrast). Transparent
-- background, so the terminal's background (opacity, blur) shows through. Ghostty's built-in
-- "Solarized Osaka Night" theme uses the same palette. Floats and popup menus follow the
-- background through transparent-popups (below), when it is enabled
-- HELP: https://github.com/craftzdog/solarized-osaka.nvim
require("solarized-osaka").setup({
	transparent = true,
	style = "vivid",
})

vim.cmd.colorscheme("solarized-osaka-vivid")

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
	dashboard.button("SPC e", "󰙅  NeoTree"),
	dashboard.button("SPC ff", "󰈞  Find file"),
	dashboard.button("SPC fg", "󰈬  Find word"),
	dashboard.button("SPC fn", "  Nvim config"),
	dashboard.button("SPC fr", "󰋚  Find recent files"),
	dashboard.button("SPC wr", "󰁯  Restore last session"),
}

alpha.setup(dashboard.opts)

-- LUALINE
require("lualine").setup({
	options = {
		theme = "auto", -- Built from the colorscheme
		icons_enabled = true,
		-- One bar for all windows when 'laststatus' is 3 (set in config/options.lua). Without it
		-- lualine puts 'laststatus' back to 2
		globalstatus = vim.o.laststatus == 3,
	},
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

-- TODO: Move to snacks
-- NOTIFY
require("notify").setup({})
vim.notify = require("notify")

-- SMEAR CURSOR
require("smear_cursor").setup({})

-- MINI.ICONS
require("mini.icons").setup({})
