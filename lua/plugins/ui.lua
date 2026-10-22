-- THEME
vim.pack.add({
  {
    src = "https://github.com/rebelot/kanagawa.nvim"
  }
})

require('kanagawa').setup({
  transparent = true,
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
