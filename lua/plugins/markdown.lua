-- #################################################################
-- Markdown and Quarto related plugins. Configures:
-- otter.nvim, quarto-nvim, jupytext.nvim
-- #################################################################

-- QUARTO-NVIM + OTTER.NVIM
-- NOTE: otter runs as a language server (otter-ls) that forwards LSP requests from code chunks to
-- hidden buffers, where basedpyright, ruff and r_language_server attach. blink.cmp picks it up
-- through its "lsp" source. Highlighting comes from treesitter (see treesitter.lua)
-- :QuartoPreview runs `quarto preview` (needs the Quarto CLI) and also works for plain .md files
-- HELP: https://github.com/quarto-dev/quarto-nvim, https://github.com/jmbuhr/otter.nvim

-- write_to_disk: lintr (through r_language_server) needs the otter buffer to exist on disk,
-- otherwise object_*_linter fail with normalizePath(). otter writes <file>.otter.<ext> on
-- save and deletes it on quit or when the main buffer is closed
require("otter").setup({
	buffers = { write_to_disk = true },
})

require("quarto").setup({
	lspFeatures = {
		languages = { "r", "python", "bash" }, -- only languages with an installed LSP
		-- "all": plain ```python fences count as chunks too, that's how jupytext writes notebook
		-- cells. The default ("curly") only takes ```{python}
		chunks = "all",
	},
	codeRunner = {
		enabled = true,
		default_method = "slime", -- send chunks to a tmux pane with vim-slime (see utilities.lua)
	},
})

-- JUPYTEXT.NVIM
-- NOTE: Opens .ipynb notebooks as markdown text and turns them back into .ipynb on save. They get
-- the quarto filetype, so otter, LSP and the run keymaps work as in a .qmd file. The jupytext CLI
-- comes from the `neovim` conda env when it exists, otherwise from PATH
-- HELP: https://github.com/goerz/jupytext.nvim, :checkhealth jupytext
local env_jupytext = vim.fn.expand("~/miniforge3/envs/neovim/bin/jupytext")
require("jupytext").setup({
	jupytext = vim.fn.executable(env_jupytext) == 1 and env_jupytext or "jupytext",
	format = "markdown",
	update = true, -- keep the outputs already stored in the .ipynb on save
	filetype = "quarto",
})
