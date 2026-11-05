-- ================================================================================================
-- TITLE : commands
-- ABOUT : user commands (:Name), one block per command
-- ================================================================================================

-- HELP: :help nvim_create_user_command()

-- Turn format-on-save off or back on for the current buffer. conform reads the variable when
-- saving, see plugins/lsp.lua
vim.api.nvim_create_user_command("ToggleFormatter", function()
	vim.b.disable_autoformat = not vim.b.disable_autoformat
	vim.notify("Format on save " .. (vim.b.disable_autoformat and "off" or "on") .. " for this buffer")
end, { desc = "Toggle format on save for the current buffer" })
