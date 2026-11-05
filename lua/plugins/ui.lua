-- #################################################################
-- Visual interface related plugins. Configures:
-- Kanagawa Theme, Alpha dashboard, Lualine, todo-comments, Notify,
-- smear-cursor, mini.icons, transparent-popups (disabled)
-- #################################################################

-- THEME
-- Transparent background. Floats and popup menus follow it through transparent-popups (below)
local transparent = true

require("kanagawa").setup({
	transparent = transparent,
	theme = "wave",
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
})

vim.cmd("colorscheme kanagawa")

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
		theme = "kanagawa",
		icons_enabled = true,
		-- One bar for all windows when 'laststatus' is 3 (set in config/options.lua). Without it
		-- lualine puts 'laststatus' back to 2
		globalstatus = vim.o.laststatus == 3,
	},
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
