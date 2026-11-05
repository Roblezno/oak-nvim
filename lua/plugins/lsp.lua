-- #################################################################
-- LSP related plugins. Configures:
-- nvim-lspconfig, mason, mason-lspconfig
-- #################################################################

-- NVIM-LSPCONFIG
-- NOTE: Only provides server configs (cmd, filetypes, root markers).
-- The LSP client itself is built into Neovim
-- HELP: :help lspconfig, :help lsp-config

-- Server overrides, merged on top of the nvim-lspconfig defaults
-- Lua: make lua_ls aware of the Neovim runtime (fixes "undefined global vim")
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})

-- R: not installed by Mason. It runs nvim-lspconfig's default cmd (R -e "languageserver::run()")
-- with the R on PATH, so the server always runs with the R that installed languageserver: the
-- active conda env's R (and its packages) or the system R. Mason builds its compiled deps with
-- the R on PATH at install time, which crashes under a conda env with another R
-- (rlang.so: undefined symbol R_MakeMissingBinding).
-- Not attached to quarto buffers: R chunks in .qmd go through otter (see plugins/markdown.lua),
-- attaching here too would duplicate completions and diagnostics.
-- R files outside a git repo run without a workspace root (single-file mode). nvim-lspconfig
-- falls back to the home folder, and languageserver then indexes every R file under it
-- (conda envs included) and stops answering.
vim.lsp.config("r_language_server", {
	filetypes = { "r", "rmd" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, ".git"))
	end,
})
if vim.fn.executable("R") == 1 then
	vim.lsp.enable("r_language_server")
end

-- MASON + MASON-LSPCONFIG
-- NOTE: mason installs the servers, mason-lspconfig enables them (vim.lsp.enable)
-- mason must be set up before mason-lspconfig
-- HELP: :help mason, :help mason-lspconfig
require("mason").setup({})
require("mason-lspconfig").setup({
	-- marksman: markdown (.md only, its default filetypes). Quarto is handled by otter (plugins/markdown.lua)
	ensure_installed = { "lua_ls", "basedpyright", "ruff", "marksman", "bashls" },
	-- r_language_server is enabled above. A Mason install left on older setups would replace
	-- its cmd (mason-lspconfig sets cmd = { "r-languageserver" })
	automatic_enable = { exclude = { "r_language_server" } },
})
