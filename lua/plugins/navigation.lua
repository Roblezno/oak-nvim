-- #################################################################
-- Navigation related plugins. Currently installed:
-- Neo Tree, Scrollbar, Telescope, Tmux-navigation
-- #################################################################


-- NEO TREE
vim.pack.add({
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },
  -- dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  -- optional, but recommended
  "https://github.com/nvim-tree/nvim-web-devicons",
})

-- SCROLLBAR
vim.pack.add({
  "https://github.com/petertriho/nvim-scrollbar"
})

require("scrollbar").setup({})


-- TELESCOPE
vim.pack.add({
  {
    src = 'https://github.com/nvim-telescope/telescope.nvim',
    version = vim.version.range('*') -- latest release tag, as the README recommends
  },
  -- dependencies (plenary.nvim and nvim-web-devicons already added with neo-tree)
  -- optional, but recommended (native sorter, built by the PackChanged hook in config/autocmds)
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})

require('telescope').setup({

})
require('telescope').load_extension('fzf')


-- TMUX NAVIGATOR
-- Disable plugin default mappings, they are defined in config/keymaps
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
  "https://github.com/christoomey/vim-tmux-navigator"
})
