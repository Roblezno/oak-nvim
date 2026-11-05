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
}
