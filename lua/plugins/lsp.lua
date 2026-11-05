-- #################################################################
-- LSP related plugins. Configures:
-- nvim-lspconfig, mason, mason-tool-installer
-- #################################################################

-- NVIM-LSPCONFIG
-- NOTE: Only provides server configs (cmd, filetypes, root markers).
-- The LSP client itself is built into Neovim. Per-server settings live in after/lsp/<name>.lua
-- HELP: :help lspconfig, :help lsp-config

-- Every server gets file-rename support, so renaming a file (in oil, for example) can update imports
-- HELP: :help vim.lsp.config()
vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
	},
})

-- R: not installed by Mason, so it only starts when R is on PATH
if vim.fn.executable("R") == 1 then
	vim.lsp.enable("r_language_server")
end

-- MASON + MASON-TOOL-INSTALLER
-- NOTE: mason installs tools and puts them on PATH, mason-tool-installer installs this list on
-- start and never updates it. The names are Mason package names, not lspconfig server names.
-- mason must be set up before mason-tool-installer
-- HELP: :help mason, :help mason-tool-installer
require("mason").setup({})
require("mason-tool-installer").setup({
	ensure_installed = {
		-- Language servers
		"basedpyright",
		"bash-language-server",
		"css-lsp",
		"eslint-lsp",
		"lua-language-server",
		"marksman", -- .md only, its default filetypes. Quarto is handled by otter (plugins/markdown.lua)
		"nextflow-language-server",
		"oxlint",
		"ruff", -- also the Python formatter
		"rust-analyzer",
		"tailwindcss-language-server",
		"vtsls",
		-- Formatters
		"oxfmt",
		"prettier",
		"prettierd",
		"shfmt",
		"stylua",
	},
	auto_update = false,
	run_on_start = true,
})

-- Servers to turn on. Only these start: anything else installed in Mason stays off.
-- r_language_server is enabled above, only when R is on PATH
-- HELP: :help vim.lsp.enable()
vim.lsp.enable({
	"basedpyright",
	"bashls",
	"cssls",
	"eslint",
	"lua_ls",
	"marksman",
	"nextflow_ls",
	"oxlint",
	"ruff",
	"rust_analyzer",
	"tailwindcss",
	"vtsls",
})
