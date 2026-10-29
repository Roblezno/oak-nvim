-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================

-- Keep desc beside callback so Neovim can display each autocmd's purpose.
-- HELP: :help nvim_create_autocmd()

-- Restore last cursor position when reopening a file
-- NOTE: First I create the group the autocmd will be part of
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
-- Now I can define the autocmd
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group, -- Assign created group to this autocmd
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"') -- Last saved cursor position
		local lcount = vim.api.nvim_buf_line_count(0) -- Number of lines in the buffer
		-- Restore only when the saved line still exists in the buffer.
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark) -- Restore the saved line and column
		end
	end,
	desc = "Restore last cursor position when reopening a file",
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*", -- Apply to every buffer
	callback = function()
		vim.hl.on_yank({ -- Acts on yank event
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
	desc = "Highlight the yanked text for 300ms",
})

-- Build telescope-fzf-native after it is installed or updated
-- NOTE: Defined here (before any vim.pack.add()) so lockfile installs also trigger it
-- HELP: :help vim.pack-events
local pack_build_group = vim.api.nvim_create_augroup("PackBuild", {})
vim.api.nvim_create_autocmd("PackChanged", {
	group = pack_build_group,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			-- :wait() so the library exists before load_extension("fzf") runs
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
	end,
	desc = "Build telescope-fzf-native after install or update",
})

-- Update treesitter parsers after nvim-treesitter is updated (parsers must match the plugin)
-- HELP: :help vim.pack-events, :help :TSUpdate
local treesitter_update_group = vim.api.nvim_create_augroup("TreesitterUpdate", {})
vim.api.nvim_create_autocmd("PackChanged", {
	group = treesitter_update_group,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			-- Load the plugin first if it is not active, so :TSUpdate exists
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
	desc = "Update treesitter parsers after nvim-treesitter is updated",
})

-- Start treesitter highlighting (provided by Neovim) for languages with an installed parser
-- NOTE: lua and markdown are already highlighted by Neovim by default
-- HELP: :help vim.treesitter.start()
local treesitter_start_group = vim.api.nvim_create_augroup("TreesitterStart", {})
vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_start_group,
	pattern = { "python", "r", "sh", "yaml", "toml", "json", "quarto" }, -- filetypes, not parser names
	callback = function(ev)
		-- pcall: on first launch parsers install asynchronously and may not be ready yet
		pcall(vim.treesitter.start, ev.buf)
	end,
	desc = "Start treesitter highlighting",
})

-- Disable Ruff hover so K shows basedpyright's type information
-- HELP: :help LspAttach
local lsp_ruff_group = vim.api.nvim_create_augroup("LspRuffHover", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_ruff_group,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "Disable Ruff hover in favor of basedpyright",
})
