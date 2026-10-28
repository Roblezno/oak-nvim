-- #################################################################
-- Visual interface related plugins. Currently installed:
-- Kanagawa Theme, Alpha dashboard, Lualine, Notify,
-- smear-cursor, mini.icons
-- #################################################################



-- THEME
vim.pack.add({
  {
    src = "https://github.com/rebelot/kanagawa.nvim"
  }
})

-- Transparent background, also applied to floating windows and popup menus
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
  -- Highlight overrides, merged into kanagawa's own groups
  -- HELP: https://github.com/rebelot/kanagawa.nvim#customization
  overrides = function()
    local hl = {
      -- blink.cmp borders use the same colour as any other float border
      BlinkCmpMenuBorder = { link = "FloatBorder" },
      BlinkCmpDocBorder = { link = "FloatBorder" },
    }
    -- Floats (LSP hover, blink.cmp docs) and popup menu (blink.cmp menu)
    if transparent then
      hl.NormalFloat = { bg = "none" }
      hl.FloatBorder = { bg = "none" }
      hl.FloatTitle = { bg = "none" }
      hl.Pmenu = { bg = "none" }
    end
    return hl
  end,
})

vim.cmd("colorscheme kanagawa")

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
