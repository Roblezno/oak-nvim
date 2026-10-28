-- #################################################################
-- Visual interface related plugins. Currently installed:
-- Kanagawa Theme, Alpha dashboard, Lualine, Notify,
-- smear-cursor, mini.icons, transparent-popups
-- #################################################################



-- THEME
vim.pack.add({
  {
    src = "https://github.com/rebelot/kanagawa.nvim"
  }
})

-- Transparent background. Floats and popup menus follow it through transparent-popups (below)
local transparent = true

require('kanagawa').setup({
  transparent = transparent,
  theme = "wave",
  colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
          },
})

vim.cmd("colorscheme kanagawa")

-- TRANSPARENT POPUPS
-- NOTE: My own plugin: float borders and transparency that follow the colorscheme, padding for
-- LSP hover and the blink.cmp menu. Must stay after the colorscheme and before completion.lua
-- (blink.cmp uses it). pcall: if it isn't installed, keep the float border and load the rest
-- HELP: https://github.com/Roblezno/nvim-transparent-popups, :checkhealth transparent-popups
vim.pack.add({
  "https://github.com/Roblezno/nvim-transparent-popups",
})
local has_transparent_popups, transparent_popups = pcall(require, "transparent-popups")
if has_transparent_popups then
  transparent_popups.setup()
else
  vim.o.winborder = "single"
  vim.notify("transparent-popups not loaded: " .. transparent_popups:match("[^\n]+"), vim.log.levels.WARN)
end

-- ALPHA STARTING WINDOW
vim.pack.add({
  {
    src = "http://github.com/goolord/alpha-nvim"
  }
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
"▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌",
"▐                                                                     ▌",
"▐                                                                     ▌",
"▐    ██████╗  █████╗ ██╗  ██╗     ███╗   ██╗██╗   ██╗██╗███╗   ███╗   ▌",
"▐   ██╔═══██╗██╔══██╗██║ ██╔╝     ████╗  ██║██║   ██║██║████╗ ████║   ▌",
"▐   ██║   ██║███████║█████╔╝█████╗██╔██╗ ██║██║   ██║██║██╔████╔██║   ▌",
"▐   ██║   ██║██╔══██║██╔═██╗╚════╝██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║   ▌",
"▐   ╚██████╔╝██║  ██║██║  ██╗     ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║   ▌",
"▐    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   ▌",
"▐                                                                     ▌",
"▐                                                                     ▌",
"▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌",
}


-- Set menu
dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", "<cmd>ene<CR>"),
  dashboard.button("SPC e", "󰙅  NeoTree"),
  dashboard.button("SPC ff", "󰈞  Find file"),
  dashboard.button("SPC fg", "󰈬  Find word"),
  dashboard.button("SPC fn", "  Nvim config"),
  dashboard.button("SPC fr", "󰋚  Find recent files"),
  dashboard.button("SPC wr", "󰁯  Restore last session"),
}

alpha.setup(dashboard.opts)


-- LUALINE
vim.pack.add({
  {
    src = "https://github.com/nvim-lualine/lualine.nvim"
  }
})

require('lualine').setup({
  options = {
    theme = "kanagawa",
    icons_enabled = true,
  }
})

-- TODO COMMENTS
vim.pack.add({
  {
    src = 'https://github.com/folke/todo-comments.nvim'
  },
  -- dependencies
  "https://github.com/nvim-lua/plenary.nvim"

})

require("todo-comments").setup({})


-- NOTIFY 
vim.pack.add({
  {
    src = 'https://github.com/rcarriga/nvim-notify'
  },

})

require("notify").setup({})
vim.notify = require("notify")

-- SMEAR CURSOR 
vim.pack.add({
  "https://github.com/sphamba/smear-cursor.nvim",
})

require('smear_cursor').setup({})


-- MINI.ICONS
vim.pack.add({
  "https://github.com/nvim-mini/mini.icons"
})

require("mini.icons").setup({})
