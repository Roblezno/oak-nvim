-- =========================================================================
-- TITLE: NeoVim Keymaps
-- ABOUT: Native editor-wide mappings; plugin mappings live in their specifications
-- HELP: :help vim.lsp.buf.format(), :help vim.ui.select(), :help package-undotree
-- ============================================================================

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>wsv", "<Cmd>vsplit<CR>", { desc = "Window split vertically" })
vim.keymap.set("n", "<leader>wsh", "<Cmd>split<CR>", { desc = "Window split horizontally" })
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Window & tmux pane navigation (vim-tmux-navigator)
vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { desc = "Go to left window/pane" })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { desc = "Go to lower window/pane" })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { desc = "Go to upper window/pane" })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { desc = "Go to right window/pane" })
vim.keymap.set("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", { desc = "Go to previous window/pane" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- NEOTREE file explorer
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', {
  desc = 'Toggle Neo-tree',
  silent = true,
})

-- WHICH-TREE Helper
vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, {
  desc = "Buffer Local Keymaps (which-key)",
})

-- TELESCOPE fuzzy finder
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', { desc = 'Telescope find recent files' })

-- LSP remaps (originaly g<t,r,a,i...>)
vim.keymap.set({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, { desc = "LSP format buffer" })
vim.keymap.set({ "n", "v" }, "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "LSP action" })
vim.keymap.set({ "n", "v" }, "<leader>li", vim.lsp.buf.implementation, { desc = "LSP go to implementation" })
vim.keymap.set({ "n", "v" }, "<leader>lR", vim.lsp.buf.references, { desc = "LSP references" })
vim.keymap.set({ "n", "v" }, "<leader>lt", vim.lsp.buf.type_definition, { desc = "LSP type deffinition" })


-- Diagnostics with T
vim.keymap.set('n', '<leader>tx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Trouble)' })

-- MARKDOWN / QUARTO (quarto-nvim)
-- NOTE: The preview opens in the browser and also works for plain .md files
vim.keymap.set("n", "<leader>mp", "<Cmd>QuartoPreview<CR>", { desc = "Quarto preview in browser" })
vim.keymap.set("n", "<leader>mq", "<Cmd>QuartoClosePreview<CR>", { desc = "Close Quarto preview" })
vim.keymap.set("n", "<leader>mi", "<Cmd>PasteImage<CR>", { desc = "Paste clipboard image (img-clip)" })

-- MOLTEN / QUARTO RUNNER (Jupyter kernels)
-- NOTE: Kernels are named after their conda env: <env> for Python, <env>-r for R, plus bash.
-- The run keymaps use quarto's runner, which sends the chunk to molten. require() is called
-- inside each function because plugins are not loaded yet when this file runs
-- HELP: :help molten, https://github.com/quarto-dev/quarto-nvim
vim.keymap.set("n", "<leader>ji", function()
  local env = vim.env.CONDA_DEFAULT_ENV
  if env and vim.tbl_contains(vim.fn.MoltenAvailableKernels(), env) then
    vim.cmd("MoltenInit " .. env)
  else
    vim.cmd("MoltenInit") -- no kernel named after the active env: open the picker
  end
end, { desc = "Molten init kernel for active conda env" })
vim.keymap.set("n", "<leader>jI", "<Cmd>MoltenInit<CR>", { desc = "Molten init kernel (picker)" })
vim.keymap.set("n", "<leader>jc", function() require("quarto.runner").run_cell() end, { desc = "Run cell" })
vim.keymap.set("n", "<leader>ja", function() require("quarto.runner").run_above() end, { desc = "Run cell and above" })
vim.keymap.set("n", "<leader>jA", function() require("quarto.runner").run_all() end, { desc = "Run all cells" })
vim.keymap.set("n", "<leader>jl", function() require("quarto.runner").run_line() end, { desc = "Run line" })
vim.keymap.set("v", "<leader>jr", function() require("quarto.runner").run_range() end, { desc = "Run selection" })
-- noautocmd: auto-open is off, so open the output window on demand without triggering it again
vim.keymap.set("n", "<leader>jo", "<Cmd>noautocmd MoltenEnterOutput<CR>", { desc = "Molten enter output" })
vim.keymap.set("n", "<leader>jh", "<Cmd>MoltenHideOutput<CR>", { desc = "Molten hide output" })
vim.keymap.set("n", "<leader>jd", "<Cmd>MoltenDelete<CR>", { desc = "Molten delete cell output" })
vim.keymap.set("n", "<leader>jx", "<Cmd>MoltenInterrupt<CR>", { desc = "Molten interrupt kernel" })
vim.keymap.set("n", "<leader>jR", "<Cmd>MoltenRestart!<CR>", { desc = "Molten restart kernel (clear outputs)" })
vim.keymap.set("n", "<leader>jq", "<Cmd>MoltenDeinit<CR>", { desc = "Molten stop kernel" })
vim.keymap.set("n", "<leader>jb", "<Cmd>MoltenOpenInBrowser<CR>", { desc = "Molten open HTML output in browser" })


