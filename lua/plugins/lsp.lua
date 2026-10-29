-- #################################################################
-- LSP related plugins. Currently installed:
-- nvim-lspconfig, mason, mason-lspconfig
-- #################################################################


-- NVIM-LSPCONFIG
-- NOTE: Only provides server configs (cmd, filetypes, root markers).
-- The LSP client itself is built into Neovim
-- HELP: :help lspconfig, :help lsp-config
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
})

-- Server overrides, merged on top of the nvim-lspconfig defaults
-- Lua: make lua_ls aware of the Neovim runtime (fixes "undefined global vim")
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

-- R: don't attach to quarto buffers. R chunks in .qmd go through otter (see plugins/markdown.lua),
-- attaching here too would duplicate completions and diagnostics
vim.lsp.config("r_language_server", {
  filetypes = { "r", "rmd" },
})


-- MASON + MASON-LSPCONFIG
-- NOTE: mason installs the servers, mason-lspconfig enables them (vim.lsp.enable)
-- mason must be set up before mason-lspconfig, and nvim-lspconfig must be added first
-- HELP: :help mason, :help mason-lspconfig
vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "basedpyright", "ruff", "r_language_server" },
})
