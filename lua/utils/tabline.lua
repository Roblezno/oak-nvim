-- ================================================================================================
-- TITLE : utils.tabline
-- ABOUT : custom tabline (no plugin): one trapezoid per tab with the file of its active window
-- USAGE : 'tabline' calls render() (config/options.lua), set_highlights() runs on ColorScheme
--         (config/autocmds.lua)
-- ================================================================================================

local M = {}

local MAX_NAME = 20 -- Longer names are cut to MAX_NAME - 3 characters plus "…"
local PAD = "   " -- 3 spaces on each side of the label
-- Both edges slant outward going down, so each tab is a trapezoid, wider at the bottom
-- (Nerd Font powerline extras: lower right and lower left triangles)
local EDGE_LEFT, EDGE_RIGHT = "\u{e0ba}", "\u{e0b8}"

--- Cut names longer than MAX_NAME characters to MAX_NAME - 3 plus "…"
---@param name string
---@return string
local function shorten(name)
	if vim.fn.strchars(name) > MAX_NAME then
		return vim.fn.strcharpart(name, 0, MAX_NAME - 3) .. "…"
	end
	return name
end

--- Cut paths longer than MAX_NAME characters to "…" plus their last MAX_NAME - 3 characters
---@param path string
---@return string
local function shorten_left(path)
	local length = vim.fn.strchars(path)
	if length > MAX_NAME then
		return "…" .. vim.fn.strcharpart(path, length - (MAX_NAME - 3))
	end
	return path
end

--- Icon and name of a buffer. Terminals, empty buffers and oil directories get no icon
---@param buf integer
---@return string|nil icon
---@return string name
local function describe(buf)
	if vim.bo[buf].buftype == "terminal" then
		return nil, "[Terminal]"
	end
	local path = vim.api.nvim_buf_get_name(buf)
	if path == "" then
		return nil, "[No Name]"
	end
	if vim.bo[buf].filetype == "oil" then
		-- nil outside the local filesystem (oil-ssh://), which falls back to the buffer name
		local dir = require("oil").get_current_dir(buf)
		-- ":h" drops the trailing slash of the directory
		return nil, shorten_left(dir and vim.fn.fnamemodify(dir, ":~:h") or path)
	end
	local file = vim.fn.fnamemodify(path, ":t")
	local ok, icons = pcall(require, "mini.icons")
	return ok and icons.get("file", file) or nil, shorten(file)
end

--- Build the tabline. Neovim calls it through 'tabline' on every redraw of the tabline
---@return string
function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local parts = {}
	for nr, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
		local icon, name = describe(buf)
		local label = (vim.bo[buf].modified and "[+] " or "") .. (icon and icon .. " " or "") .. name
		local text = label:gsub("%%", "%%%%") -- A literal % must be doubled in 'tabline'
		local hl = tab == current and "TablineActive" or "TablineInactive"
		parts[#parts + 1] = table.concat({
			"%" .. nr .. "T", -- Clicking the tab goes to it
			"%#" .. hl .. "Edge#" .. EDGE_LEFT,
			"%#" .. hl .. "#" .. PAD .. text .. PAD,
			"%#" .. hl .. "Edge#" .. EDGE_RIGHT,
		})
	end
	return table.concat(parts) .. "%#TablineEmpty#%T"
end

--- Tab colors: the solarized-osaka palette, or TabLineSel/TabLine with any other colorscheme
---@return table
local function colors()
	if (vim.g.colors_name or ""):find("^solarized%-osaka") then
		local ok, c = pcall(function()
			return require("solarized-osaka.colors").setup()
		end)
		if ok then
			return { active_fg = c.base4, active_bg = c.yellow, inactive_fg = c.base0, inactive_bg = c.base02 }
		end
	end
	local sel = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
	local tab = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
	return { active_fg = sel.fg, active_bg = sel.bg, inactive_fg = tab.fg, inactive_bg = tab.bg }
end

--- (Re)create the tabline highlight groups. A colorscheme clears them, so this runs on ColorScheme
--- HELP: :help 'tabline', :help nvim_set_hl()
function M.set_highlights()
	local c = colors()
	-- The edges take the tab's color on a transparent background, like the empty area after the
	-- last tab. The icon takes the tab's text color (no highlight of its own)
	vim.api.nvim_set_hl(0, "TablineActive", { fg = c.active_fg, bg = c.active_bg, bold = true })
	vim.api.nvim_set_hl(0, "TablineActiveEdge", { fg = c.active_bg })
	vim.api.nvim_set_hl(0, "TablineInactive", { fg = c.inactive_fg, bg = c.inactive_bg })
	vim.api.nvim_set_hl(0, "TablineInactiveEdge", { fg = c.inactive_bg })
	vim.api.nvim_set_hl(0, "TablineEmpty", {})
end

return M
