-- #################################################################
-- LSP related plugins. Configures:
-- nvim-lspconfig, mason, mason-tool-installer
-- #################################################################

-- NVIM-LSPCONFIG
-- NOTE: Only provides server configs (cmd, filetypes, root markers).
-- The LSP client itself is built into Neovim
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
		"copilot-language-server", -- installed only, not enabled below
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
