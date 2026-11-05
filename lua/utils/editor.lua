-- ================================================================================================
-- TITLE : utils.editor
-- ABOUT : editor helpers (buffers, windows) used by keymaps and commands
-- USAGE : require("utils").editor.<function>()
-- ================================================================================================

local M = {}

--- Close every hidden buffer, except unsaved ones.
--- Hidden: a listed file buffer that is not shown in any window of any tab. Special buffers
--- (terminals, help, quickfix, plugin buffers) are left alone. :bdelete keeps marks and jumps to
--- the file working, unlike wiping the buffer
--- HELP: :help hidden-buffer, :help :bdelete
function M.close_hidden_buffers()
	local shown = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		shown[vim.api.nvim_win_get_buf(win)] = true
	end

	local closed, kept = 0, 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local bo = vim.bo[buf]
		if bo.buflisted and bo.buftype == "" and not shown[buf] then
			if bo.modified then
				kept = kept + 1
			elseif pcall(vim.cmd, "bdelete " .. buf) then
				closed = closed + 1
			end
		end
	end

	local msg = ("Closed %d hidden buffer%s"):format(closed, closed == 1 and "" or "s")
	if kept > 0 then
		msg = msg .. (", kept %d unsaved"):format(kept)
	end
	vim.notify(msg)
end

return M
