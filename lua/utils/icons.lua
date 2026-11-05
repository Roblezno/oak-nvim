-- ================================================================================================
-- TITLE : utils.icons
-- ABOUT : the shared icon set, so everything that shows these icons uses the same ones
-- USAGE : require("utils").icons.diagnostics.error
-- ================================================================================================

return {
	diagnostics = {
		error = "\u{f057}", -- nf-fa-times_circle
		warn = "\u{f071}", -- nf-fa-warning
		info = "\u{f05a}", -- nf-fa-info_circle
		hint = "\u{f0eb}", -- nf-fa-lightbulb_o
	},
	-- Completion item kinds. The same glyphs as blink.cmp's defaults
	kinds = {
		Text = "\u{f027f}",
		Method = "\u{f0295}",
		Function = "\u{f0295}",
		Constructor = "\u{f0493}",
		Field = "\u{f0722}",
		Variable = "\u{f01a6}",
		Property = "\u{f05b7}",
		Class = "\u{f1860}",
		Interface = "\u{f1860}",
		Struct = "\u{f1860}",
		Module = "\u{f0169}",
		Unit = "\u{f0a9a}",
		Value = "\u{f09a8}",
		Enum = "\u{f09a8}",
		EnumMember = "\u{f09a8}",
		Keyword = "\u{f0efe}",
		Constant = "\u{f03ff}",
		Snippet = "\u{f113d}",
		Color = "\u{f03d8}",
		File = "\u{f0214}",
		Reference = "\u{f0b32}",
		Folder = "\u{f024b}",
		Event = "\u{f140b}",
		Operator = "\u{f0a9a}",
		TypeParameter = "\u{f0b1b}",
	},
}
