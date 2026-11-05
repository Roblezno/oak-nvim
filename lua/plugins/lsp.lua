-- #################################################################
-- LSP related plugins. Configures:
-- nvim-lspconfig, mason, mason-tool-installer, conform
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

-- CONFORM
-- NOTE: Formats on save, falling back to the language server for filetypes not listed here.
-- :ToggleFormatter turns it off for a buffer (see config/commands.lua). mason-tool-installer
-- installs the formatters above, fish_indent comes with fish
-- HELP: :help conform, :ConformInfo

-- oxfmt only runs in projects with an oxfmt config, so projects using prettier keep it. Every Vite
-- project has a vite.config.ts, so that file only counts if it sets up Vite+ with a fmt field
---@param ctx conform.Context
---@return boolean
local function has_oxfmt_config(_, ctx)
	local function find(names)
		return vim.fs.find(names, { path = ctx.dirname, upward = true })[1]
	end
	if find({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }) then
		return true
	end
	local vite_config = find("vite.config.ts")
	if not vite_config then
		return false
	end
	local text = table.concat(vim.fn.readfile(vite_config), "\n")
	return text:find("vite-plus", 1, true) ~= nil and text:find("fmt:", 1, true) ~= nil
end

-- The first one available runs
local web_formatters = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
	formatters_by_ft = {
		css = web_formatters,
		fish = { "fish_indent" },
		html = web_formatters,
		javascript = web_formatters,
		javascriptreact = web_formatters,
		json = web_formatters,
		less = web_formatters,
		lua = { "stylua" },
		markdown = web_formatters,
		mdx = web_formatters,
		python = { "ruff_format" },
		scss = web_formatters,
		sh = { "shfmt" },
		typescript = web_formatters,
		typescriptreact = web_formatters,
		yaml = web_formatters,
	},
	formatters = {
		oxfmt = { condition = has_oxfmt_config },
	},
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
