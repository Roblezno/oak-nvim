-- #################################################################
-- Utility tools and Quality of Life related plugins. 
-- Nvim-autopairs, which-key, Trouble, Noice
-- #################################################################


-- NVIM-AUTOPAIRS
vim.pack.add({
  "https://github.com/windwp/nvim-autopairs",
})

require('nvim-autopairs').setup({
  event = "InsertENter",
  config = true
})


-- WHICH-KEY
vim.pack.add({
  "https://github.com/folke/which-key.nvim"
})

require("which-key").setup({})


-- TROUBLE
vim.pack.add({
  "https://github.com/folke/trouble.nvim"
})

require("trouble").setup({})


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
-- markdown/quarto it shows the image link under the cursor in a popup. "magick_cli" uses the
-- ImageMagick CLI, so no luarocks are needed. Inside tmux it needs `allow-passthrough on` and
-- `visual-activity off` in ~/.tmux.conf
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
  -- clear images covered by floating windows, except the floats listed here: blink.cmp menus,
  -- floats without a filetype (""), smear-cursor's 1x1 cursor floats and notify's popups
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = {
    "blink-cmp-menu", "blink-cmp-documentation", "blink-cmp-signature", "",
    "smear-cursor", "notify",
  },
  tmux_show_only_in_active_window = true,
})


