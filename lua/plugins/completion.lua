-- #################################################################
-- Completion related plugins. Currently installed:
-- blink.cmp, friendly-snippets
-- #################################################################


-- BLINK.CMP
-- NOTE: Pinned to 1.* release tags so the prebuilt fuzzy matcher is downloaded
-- automatically (no build step). LSP capabilities are registered automatically
-- on Neovim 0.11+, so no changes are needed in lsp.lua
-- friendly-snippets: community snippets, picked up by the default snippets source
-- HELP: :help blink-cmp
vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
  -- <C-y> accept, <C-n>/<C-p> navigate, <C-space> open menu/docs, <C-e> hide
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  -- Rust matcher (prebuilt binary), falls back to Lua with a warning if unavailable
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
