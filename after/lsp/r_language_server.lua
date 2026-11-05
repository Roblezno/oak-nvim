-- r_language_server settings, merged on top of the nvim-lspconfig defaults
-- NOTE: Not installed by Mason. It runs nvim-lspconfig's default cmd (R -e "languageserver::run()")
-- with the R on PATH, so the server always runs with the R that installed languageserver: the
-- active conda env's R (and its packages) or the system R. Mason builds its compiled deps with
-- the R on PATH at install time, which crashes under a conda env with another R
-- (rlang.so: undefined symbol R_MakeMissingBinding).
-- HELP: :help lsp-config-merge

return {
	-- Not attached to quarto buffers: R chunks in .qmd go through otter (see plugins/markdown.lua),
	-- attaching here too would duplicate completions and diagnostics
	filetypes = { "r", "rmd" },
	-- R files outside a git repo run without a workspace root (single-file mode). nvim-lspconfig
	-- falls back to the home folder, and languageserver then indexes every R file under it
	-- (conda envs included) and stops answering
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, ".git"))
	end,
}
