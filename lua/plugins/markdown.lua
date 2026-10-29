-- #################################################################
-- Markdown and Quarto related plugins. Currently installed:
-- otter.nvim, quarto-nvim
-- #################################################################


-- QUARTO-NVIM + OTTER.NVIM
-- NOTE: otter runs as a language server (otter-ls) that forwards LSP requests from code chunks to
-- hidden buffers, where basedpyright, ruff and r_language_server attach. blink.cmp picks it up
-- through its "lsp" source. Highlighting comes from treesitter (see treesitter.lua)
-- :QuartoPreview runs `quarto preview` (needs the Quarto CLI) and also works for plain .md files
-- HELP: https://github.com/quarto-dev/quarto-nvim, https://github.com/jmbuhr/otter.nvim
vim.pack.add({
  "https://github.com/jmbuhr/otter.nvim",
  "https://github.com/quarto-dev/quarto-nvim",
})

require("quarto").setup({
  lspFeatures = {
    languages = { "r", "python" }, -- only languages with an installed LSP
  },
  codeRunner = { enabled = false }, -- no REPL/Jupyter runner installed
})
