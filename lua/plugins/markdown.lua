-- #################################################################
-- Markdown and Quarto related plugins. Currently installed:
-- otter.nvim, quarto-nvim, img-clip.nvim, image.nvim
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
  codeRunner = { enabled = false }, -- no REPL/Jupyter runner installed
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
  -- clear images covered by floating windows, except blink's popups and floats with no filetype
  -- ("" is from molten's recommended config)
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = {
    "blink-cmp-menu", "blink-cmp-documentation", "blink-cmp-signature", "",
  },
  tmux_show_only_in_active_window = true,
})
