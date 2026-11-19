-- #################################################################
-- Markdown and Quarto related plugins. Configures:
-- otter.nvim, quarto-nvim, jupytext.nvim, molten-nvim
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

-- Cells go to molten when the buffer has a kernel (<leader>ji starts one), otherwise to the tmux
-- pane through vim-slime. quarto calls this on every run, so starting or stopping a kernel
-- switches the runner right away. vim.b.molten_kernel is set in config/autocmds.lua
local function run_cell(cell, ignore_cols)
	local runner = vim.b.molten_kernel and "molten" or "slime"
	require("quarto.runner." .. runner).run(cell, ignore_cols)
end

require("quarto").setup({
	lspFeatures = {
		languages = { "r", "python", "bash" }, -- only languages with an installed LSP
		-- "all": plain ```python fences count as chunks too, that's how jupytext writes notebook
		-- cells. The default ("curly") only takes ```{python}
		chunks = "all",
	},
	codeRunner = {
		enabled = true,
		default_method = run_cell, -- molten or vim-slime (see utilities.lua), chosen per buffer
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

-- MOLTEN-NVIM
-- NOTE: Runs cells in Jupyter kernels and shows their text output under each cell. Nothing is
-- drawn in the terminal (images glitched and slowed the buffer down): plots open in the system
-- image viewer instead. It is a Python remote plugin: its deps live in the `neovim` conda env
-- (python3_host_prog in config/options.lua) and :UpdateRemotePlugins registers its commands
-- (config/autocmds.lua). Restart nvim after the first install. Options are read from vim.g when
-- molten starts. Keymaps under <leader>j, see plugins/keymaps.lua
-- HELP: https://github.com/benlubas/molten-nvim, :checkhealth molten
vim.g.molten_image_provider = "none" -- no images in the terminal
vim.g.molten_auto_image_popup = true -- open each plot in the system image viewer (needs pillow)
vim.g.molten_virt_text_output = true -- show output as virtual text under the cell
vim.g.molten_virt_text_max_lines = 4 -- keep it short, <leader>jo opens the full output
vim.g.molten_virt_lines_off_by_1 = true -- put that output below the closing ``` of the cell
vim.g.molten_auto_open_output = false -- open the output window on demand (<leader>jo)
vim.g.molten_wrap_output = true
vim.g.molten_output_win_max_height = 20
