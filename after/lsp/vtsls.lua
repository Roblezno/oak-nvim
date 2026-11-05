-- vtsls settings, merged on top of the nvim-lspconfig defaults
-- HELP: :help lsp-config-merge, https://github.com/yioneko/vtsls

-- Shared by TypeScript and JavaScript
local language = {
	updateImportsOnFileMove = { enabled = "always" },
	suggest = { completeFunctionCalls = true },
	-- <leader>th shows the hints
	inlayHints = {
		enumMemberValues = { enabled = true },
		functionLikeReturnTypes = { enabled = true },
		parameterNames = { enabled = "literals" },
		parameterTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

return {
	settings = {
		typescript = language,
		javascript = language,
		vtsls = {
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = { enableServerSideFuzzyMatch = true },
			},
		},
	},
}
