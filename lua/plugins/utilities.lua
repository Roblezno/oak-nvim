-- #################################################################
-- Utility tools and Quality of Life related plugins. 
-- Nvim-autopairs, which-key
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


