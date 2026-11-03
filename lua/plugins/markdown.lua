-- #################################################################
-- Markdown and Quarto related plugins. Currently installed:
-- otter.nvim, quarto-nvim, img-clip.nvim, image.nvim, molten-nvim
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

-- write_to_disk: lintr (through r_language_server) needs the otter buffer to exist on disk,
-- otherwise object_*_linter fail with normalizePath(). otter writes <file>.otter.<ext> on
-- save and deletes it on quit or when the main buffer is closed
require("otter").setup({
  buffers = { write_to_disk = true },
})

require("quarto").setup({
  lspFeatures = {
    languages = { "r", "python", "bash" }, -- only languages with an installed LSP
  },
  codeRunner = {
    enabled = true,
    default_method = "molten", -- run chunks in Jupyter kernels (see MOLTEN-NVIM below)
  },
})


-- MOLTEN-NVIM
-- NOTE: Runs code chunks in Jupyter kernels and shows the output under each chunk (plots through
-- image.nvim). It is a Python remote plugin: its deps live in the `neovim` conda env (see
-- python3_host_prog in options.lua) and :UpdateRemotePlugins registers its commands (see
-- autocmds.lua). Restart nvim after the first install. Pinned to 1.x as molten recommends.
-- Options are read from vim.g, so they are set before the plugin loads
-- HELP: https://github.com/benlubas/molten-nvim, :checkhealth molten
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_auto_open_output = false -- open the output window on demand (:MoltenEnterOutput)
vim.g.molten_virt_text_output = true -- show output as virtual text under the chunk
vim.g.molten_virt_lines_off_by_1 = true -- put that output below the closing ``` of the chunk
vim.g.molten_wrap_output = true
vim.g.molten_output_win_max_height = 20

vim.pack.add({
  { src = "https://github.com/benlubas/molten-nvim", version = vim.version.range("1.*") },
})
