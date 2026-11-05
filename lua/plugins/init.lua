-- #################################################################
-- Plugin entry point: installs every plugin in one vim.pack.add()
-- call, then requires each group file to configure them
-- #################################################################

-- NOTE: During init.lua, vim.pack.add() works like :packadd!. Plugins land on the runtimepath (so
-- require() works right away), but their plugin/ files are only sourced after init.lua finishes.
-- That's why the group files can still set the vim.g options a plugin reads when it loads
-- (vim-slime, vim-tmux-navigator). Changing a plugin's src makes vim.pack reinstall it
-- HELP: :help vim.pack, :help vim.pack.add()
vim.pack.add({
	-- ui.lua
	"https://github.com/craftzdog/solarized-osaka.nvim",
	-- "https://github.com/Roblezno/nvim-transparent-popups",
	"http://github.com/goolord/alpha-nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/sphamba/smear-cursor.nvim",
	"https://github.com/nvim-mini/mini.icons",
	-- utilities.lua
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/HakonHarnes/img-clip.nvim",
	"https://github.com/3rd/image.nvim",
	"https://github.com/jpalardy/vim-slime",
	-- navigation.lua
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },
	"https://github.com/petertriho/nvim-scrollbar",
	-- latest release tag, as the README recommends
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("*") },
	-- native sorter, built by the PackChanged hook in config/autocmds.lua
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
	-- treesitter.lua (master is the old, frozen API)
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	-- lsp.lua
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	-- completion.lua
	"https://github.com/rafamadriz/friendly-snippets",
	-- 1.* release tags, so the prebuilt fuzzy matcher is downloaded (no build step)
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	-- markdown.lua
	"https://github.com/jmbuhr/otter.nvim",
	"https://github.com/quarto-dev/quarto-nvim",
	-- shared dependencies
	"https://github.com/nvim-lua/plenary.nvim", -- neo-tree, telescope, todo-comments
	"https://github.com/MunifTanjim/nui.nvim", -- neo-tree
	"https://github.com/nvim-tree/nvim-web-devicons", -- neo-tree, telescope (optional)
})

-- Plugin groups. Order matters:
-- - ui goes first: it sets the colorscheme, and completion.lua uses transparent-popups when it is
--   installed
-- - keymaps goes last, so every plugin is set up before its keymaps are defined
require("plugins.ui")
require("plugins.utilities")
require("plugins.navigation")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")
require("plugins.markdown")
require("plugins.keymaps")
