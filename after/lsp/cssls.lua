-- cssls settings, merged on top of the nvim-lspconfig defaults
-- HELP: :help lsp-config-merge

-- Empty rules are common while writing styles, so they aren't flagged
local lint = { lint = { emptyRules = "ignore" } }

return {
	settings = {
		css = lint,
		scss = lint,
		less = lint,
	},
}
