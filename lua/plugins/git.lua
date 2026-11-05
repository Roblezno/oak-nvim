-- #################################################################
-- Git related plugins. Configures:
-- gitsigns, mini.diff
-- #################################################################

-- GITSIGNS
-- NOTE: Signs, blame and staging, with its defaults. Keymaps live in plugins/keymaps.lua
-- HELP: :help gitsigns
require("gitsigns").setup({})

-- MINI.DIFF
-- NOTE: Only here for the overlay. gitsigns keeps the signs and staging, so the "number" style
-- avoids a second set of signs, and all of mini.diff's own mappings are off (gH would discard
-- changes). Keymaps live in plugins/keymaps.lua
-- overlay_style comes from craftzdog's fork (see plugins/init.lua): "hunk" groups changes into whole
-- hunks, the way `git diff` shows them. Its default, "line", would look like upstream mini.diff
-- HELP: :help mini.diff, https://github.com/craftzdog/mini.diff/tree/feat/grouping
require("mini.diff").setup({
	view = { style = "number", overlay_style = "hunk" },
	mappings = {
		apply = "",
		reset = "",
		textobject = "",
		goto_first = "",
		goto_prev = "",
		goto_next = "",
		goto_last = "",
	},
})
