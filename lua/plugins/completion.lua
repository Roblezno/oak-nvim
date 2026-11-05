-- #################################################################
-- Completion related plugins. Configures:
-- blink.cmp, friendly-snippets
-- #################################################################

-- BLINK.CMP
-- NOTE: Pinned to 1.* release tags (plugins/init.lua) so the prebuilt fuzzy matcher is downloaded
-- automatically (no build step). LSP capabilities are registered automatically
-- on Neovim 0.11+, so no changes are needed in lsp.lua
-- friendly-snippets: community snippets, picked up by the default snippets source
-- HELP: :help blink-cmp

-- Menu padding and borders come from transparent-popups (loaded in ui.lua), when it is available.
-- Options set below are merged on top of them and win
local has_transparent_popups, transparent_popups = pcall(require, "transparent-popups")
local popup_opts = has_transparent_popups and transparent_popups.blink_opts and transparent_popups.blink_opts() or {}
require("blink.cmp").setup(vim.tbl_deep_extend("force", popup_opts, {
	-- <CR> accept, <C-n>/<C-p> or <Up>/<Down> navigate, <C-space> open menu/docs, <C-e> hide
	keymap = { preset = "enter" },
	appearance = { kind_icons = require("utils").icons.kinds },
	completion = {
		accept = { auto_brackets = { enabled = true } }, -- Add brackets after functions
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		menu = { draw = { treesitter = { "lsp" } } }, -- Colorize language server items with treesitter
		ghost_text = { enabled = false }, -- It would clash with Copilot's inline suggestions
	},
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	-- Rust matcher (prebuilt binary), falls back to Lua with a warning if unavailable
	fuzzy = { implementation = "prefer_rust_with_warning" },
	-- Command line: menu pops up automatically for ':' commands only (not '/' '?' searches), with
	-- nothing preselected, so <CR> runs what was typed
	-- <Tab> show, then accept the selected item or the first one. <C-n>/<C-p> or <Left>/<Right>
	-- navigate, <C-e> cancel
	cmdline = {
		keymap = {
			preset = "cmdline",
			-- select_and_accept, because accept alone does nothing while no item is selected
			["<Tab>"] = { "show", "select_and_accept" },
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
		},
	},
}))
