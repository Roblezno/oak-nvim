-- #################################################################
-- Treesitter related plugins. Configures:
-- nvim-treesitter
-- #################################################################

-- NVIM-TREESITTER
-- NOTE: The main branch only installs parsers and queries. Highlighting and folding are provided
-- by Neovim itself, indentation by the plugin's indentexpr (see config/autocmds and config/options)
-- HELP: :help nvim-treesitter, :help treesitter

-- Install parsers (asynchronous, no-op if already installed)
-- NOTE: Neovim bundles a few of these (c, lua, markdown, vim, vimdoc...). The copies installed here
-- come first on the runtimepath, so they win and stay in sync with nvim-treesitter's queries
require("nvim-treesitter").install({
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"python",
	"query",
	"r",
	"regex",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
})

-- Quarto (.qmd) has no parser of its own: use the markdown one. Code chunks and the YAML header
-- are injected by the markdown queries bundled with Neovim
-- NOTE: quarto-nvim also does this in its ftplugin. Registering it here keeps highlighting and
-- folding independent of plugin load order
-- HELP: :help vim.treesitter.language.register()
vim.treesitter.language.register("markdown", "quarto")
