-- ================================================================================================
-- TITLE : utils.git
-- ABOUT : git helpers for keymaps that need more than one gitsigns call
-- USAGE : require("utils").git.<function>()
-- ================================================================================================

local M = {}

--- Stage the buffer, or unstage it if nothing is left to stage
function M.toggle_stage_buffer()
	local gitsigns = require("gitsigns")
	local hunks = gitsigns.get_hunks()
	if not hunks then
		vim.notify("Not a file tracked by git", vim.log.levels.WARN)
	elseif #hunks > 0 then
		gitsigns.stage_buffer()
	else
		gitsigns.reset_buffer_index()
	end
end

--- Open the file as it was in the commit that last touched the cursor line, in a new tab and on
--- that line. It blames the buffer's text, so unsaved edits don't shift the line
function M.open_line_commit()
	local file = vim.api.nvim_buf_get_name(0)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local command = { "git", "blame", "--porcelain", "--contents", "-", "-L", line .. "," .. line, "--", file }
	local blame = vim.system(command, {
		cwd = vim.fs.dirname(file),
		stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false),
		text = true,
	}):wait()

	-- The first line is "<commit> <line in that commit> <line now> ..."
	local commit, commit_line = blame.stdout:match("^(%x+) (%d+)")
	if blame.code ~= 0 or not commit then
		vim.notify("Not a file tracked by git", vim.log.levels.WARN)
		return
	end
	if commit:match("^0+$") then
		vim.notify("This line isn't committed yet")
		return
	end

	-- The path in that commit, relative to the repository root. Renames make it differ from the
	-- current one
	local path = blame.stdout:match("\nfilename ([^\n]+)")
	require("gitsigns").show(commit .. ":" .. path, { open = "tabnew" }, function(err)
		if not err then
			pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(commit_line), 0 })
		end
	end)
end

return M
