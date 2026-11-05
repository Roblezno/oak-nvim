-- #################################################################
-- Navigation related plugins. Configures:
-- Neo Tree, Scrollbar, Telescope, Tmux-navigation
-- #################################################################

-- NEO TREE
-- NOTE: No setup() call, it runs with its defaults

-- SCROLLBAR
require("scrollbar").setup({})

-- TELESCOPE
-- NOTE: fzf is the native sorter, built by the PackChanged hook in config/autocmds.lua
require("telescope").setup({})
require("telescope").load_extension("fzf")

-- TMUX NAVIGATOR
-- Disable plugin default mappings, they are defined in plugins/keymaps.lua
-- NOTE: Read when the plugin loads, after init.lua, so setting it here is early enough
-- (see plugins/init.lua)
vim.g.tmux_navigator_no_mappings = 1
