-- ================================================================================================
-- TITLE : utils.lsp
-- ABOUT : LSP helpers that need more than a one-line keymap
-- USAGE : require("utils").lsp.<function>()
-- ================================================================================================

local M = {}

--- Go to the real code in TypeScript, skipping the .d.ts files. Other languages go to the
--- implementation
--- HELP: https://github.com/yioneko/vtsls
function M.goto_source_definition()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not client then
		require("telescope.builtin").lsp_implementations()
		return
	end
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("workspace/executeCommand", {
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, function(err, locations)
		if err or not locations or #locations == 0 then
			vim.notify("No source definition found")
			return
		end
		vim.lsp.util.show_document(locations[1], client.offset_encoding, { focus = true })
	end, 0)
end

return M
