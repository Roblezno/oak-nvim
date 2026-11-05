-- ================================================================================================
-- TITLE : utils
-- ABOUT : shared helpers. Returns a table of helper modules, e.g. utils/editor.lua as `editor`
-- USAGE : local utils = require("utils")
-- ================================================================================================

return {
	editor = require("utils.editor"),
	tabline = require("utils.tabline"),
}
