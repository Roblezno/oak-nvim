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

require("quarto").setup({
  lspFeatures = {
    languages = { "r", "python", "bash" }, -- only languages with an installed LSP
  },
  codeRunner = {
    enabled = true,
    default_method = "molten", -- run chunks in Jupyter kernels (see MOLTEN-NVIM below)
  },
})


-- IMG-CLIP.NVIM
-- NOTE: Pastes a clipboard image into an assets/ folder next to the current file and inserts the
-- markdown link. The defaults already cover markdown and quarto. Needs wl-clipboard on Wayland
-- (xclip on X11)
-- HELP: https://github.com/HakonHarnes/img-clip.nvim, :checkhealth img-clip
vim.pack.add({
  "https://github.com/HakonHarnes/img-clip.nvim",
})

require("img-clip").setup({
  default = {
    relative_to_current_file = true, -- assets/ next to the file, not in the cwd
  },
})


-- IMAGE.NVIM
-- NOTE: Draws images inside nvim with the kitty graphics protocol (Ghostty implements it). In
-- markdown/quarto it shows the image link under the cursor in a popup, and molten uses it for plot
-- outputs. "magick_cli" uses the ImageMagick CLI, so no luarocks are needed. Inside tmux it needs
-- `allow-passthrough on` and `visual-activity off` in ~/.tmux.conf
-- HELP: https://github.com/3rd/image.nvim, :checkhealth image
vim.pack.add({
  "https://github.com/3rd/image.nvim",
})

require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  integrations = {
    markdown = {
      filetypes = { "markdown", "quarto" },
      only_render_image_at_cursor = true,
      only_render_image_at_cursor_mode = "popup",
    },
  },
  -- sizing recommended by molten for plot outputs
  max_width = 100,
  max_height = 12,
  max_width_window_percentage = math.huge,
  max_height_window_percentage = math.huge,
  -- clear images covered by floating windows, except the floats listed here. "" is from molten's
  -- recommended config. smear-cursor leaves 1x1 floats around the window that would hide every
  -- molten plot, and notify's popups would hide plots in the top-right
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = {
    "blink-cmp-menu", "blink-cmp-documentation", "blink-cmp-signature", "",
    "smear-cursor", "notify",
  },
  tmux_show_only_in_active_window = true,
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
