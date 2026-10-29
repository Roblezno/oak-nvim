-- #################################################################
-- Treesitter related plugins. Currently installed:
-- nvim-treesitter
-- #################################################################


-- NVIM-TREESITTER
-- NOTE: The main branch only installs parsers and queries. Highlighting and folding are
-- provided by Neovim itself (see config/autocmds and config/options)
-- HELP: :help nvim-treesitter, :help treesitter
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main", -- master is the old, frozen API
  },
})

-- Install parsers (asynchronous, no-op if already installed)
-- NOTE: c, lua, markdown, markdown_inline, query, vim and vimdoc are bundled with Neovim
require("nvim-treesitter").install({
  "python",
  "r",
  "bash",
  "yaml",
  "toml",
  "json",
})

-- Quarto (.qmd) has no parser of its own: use the markdown one. Code chunks and the YAML header
-- are injected by the markdown queries bundled with Neovim
-- NOTE: quarto-nvim also does this in its ftplugin. Registering it here keeps highlighting and
-- folding independent of plugin load order
-- HELP: :help vim.treesitter.language.register()
vim.treesitter.language.register("markdown", "quarto")
