-- ================================================================================================
-- TITLE : init.lua
-- ABOUT : entry point. Loads the plain Neovim settings first, then the plugins
-- ================================================================================================

-- Byte-compile and cache Lua modules for a faster startup
-- HELP: :help vim.loader.enable()
vim.loader.enable()

-- Plain Neovim settings (lua/config). options goes first: it sets the leader keys
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.workarounds")

-- Plugins (lua/plugins/init.lua): installs every plugin, then configures each group
require("plugins")
