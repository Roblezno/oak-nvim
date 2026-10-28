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

-- Menu padding and borders come from transparent-popups (loaded in ui.lua).
-- Options set below are merged on top of them and win
require("blink.cmp").setup(vim.tbl_deep_extend("force", require("transparent-popups").blink_opts(), {
  -- <C-y> accept, <C-n>/<C-p> navigate, <C-space> open menu/docs, <C-e> hide
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  -- Rust matcher (prebuilt binary), falls back to Lua with a warning if unavailable
  fuzzy = { implementation = "prefer_rust_with_warning" },
  -- Command line: menu pops up automatically for ':' commands only (not '/' '?' searches)
  -- <Tab> show/accept, <C-n>/<C-p> or <Left>/<Right> navigate, <C-e> cancel
  cmdline = {
    keymap = {
      preset = "cmdline",
      ["<Tab>"] = { "show", "accept" },
    },
    completion = {
      menu = {
        auto_show = function()
          return vim.fn.getcmdtype() == ":"
        end,
      },
    },
  },
}))
