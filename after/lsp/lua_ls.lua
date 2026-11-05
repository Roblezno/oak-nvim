-- lua_ls settings, merged on top of the nvim-lspconfig defaults
-- HELP: :help lsp-config-merge, https://luals.github.io/wiki/settings/

return {
	settings = {
		Lua = {
			-- Make lua_ls aware of the Neovim runtime (fixes "undefined global vim")
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			-- Parameter types only. <leader>th shows the hints
			hint = {
				enable = true,
				paramType = true,
				paramName = "Disable",
				arrayIndex = "Disable",
				semicolon = "Disable",
			},
			-- Noisy checks: stylua removes trailing spaces, and setup() tables rarely set every field
			diagnostics = { disable = { "missing-fields", "trailing-space" } },
		},
	},
}
