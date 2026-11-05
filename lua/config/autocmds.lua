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

-- Highlight the yanked text for 300ms
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

-- Tabline colors from the colorscheme palette (the tabline itself is set in config/options.lua)
-- NOTE: Defined before plugins/ui.lua loads the colorscheme, so it also runs for the first one
-- HELP: :help ColorScheme
local tabline_colors_group = vim.api.nvim_create_augroup("TablineColors", {})
vim.api.nvim_create_autocmd("ColorScheme", {
	group = tabline_colors_group,
	callback = function()
		require("utils.tabline").set_highlights()
	end,
	desc = "Set the tabline colors",
})

-- Show the cursorline only in the active window
-- NOTE: It only comes back in windows where it was hidden here, so floats and plugin windows that
-- keep it off (pickers, popups) are left alone. setlocal keeps the global value on
-- HELP: :help 'cursorline', :help WinLeave, :help WinEnter
local active_cursorline_group = vim.api.nvim_create_augroup("ActiveCursorline", {})
vim.api.nvim_create_autocmd("WinLeave", {
	group = active_cursorline_group,
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true -- Mark it, so WinEnter knows to bring it back
			vim.opt_local.cursorline = false
		end
	end,
	desc = "Hide the cursorline when leaving a window",
})
vim.api.nvim_create_autocmd("WinEnter", {
	group = active_cursorline_group,
	callback = function()
		if vim.w.auto_cursorline then
			vim.w.auto_cursorline = nil
			vim.opt_local.cursorline = true
		end
	end,
	desc = "Show the cursorline again when entering a window",
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

-- Start treesitter highlighting (provided by Neovim) and indentation (provided by nvim-treesitter)
-- for every filetype with a parser
-- NOTE: language.add() returns nil without a parser, which also covers the first launch, when
-- parsers are still installing. The parser name can differ from the filetype (sh uses bash, quarto
-- uses markdown). Languages without indent queries keep their filetype's own indentation
-- HELP: :help vim.treesitter.start(), :help vim.treesitter.language.add(), :help nvim-treesitter
local treesitter_start_group = vim.api.nvim_create_augroup("TreesitterStart", {})
vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_start_group,
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.treesitter.start(ev.buf, lang)
		if #vim.treesitter.query.get_files(lang, "indents") > 0 then
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
	desc = "Start treesitter highlighting and indentation",
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

-- Turn off Neovim's LSP document colors, so nvim-highlight-colors doesn't paint them twice
-- NOTE: LspAttach fires for each client, so servers that attach later are covered too
-- HELP: :help vim.lsp.document_color.enable()
local lsp_document_color_group = vim.api.nvim_create_augroup("LspDocumentColor", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_document_color_group,
	callback = function(ev)
		vim.lsp.document_color.enable(false, { bufnr = ev.buf })
	end,
	desc = "Disable LSP document colors in favor of nvim-highlight-colors",
})

-- Nextflow comment style, so `gc` works (Neovim ships no ftplugin for Nextflow)
-- NOTE: The nextflow filetype is detected in config/options.lua
-- HELP: :help 'commentstring', :help commenting
local nextflow_buffer_group = vim.api.nvim_create_augroup("NextflowBuffer", {})
vim.api.nvim_create_autocmd("FileType", {
	group = nextflow_buffer_group,
	pattern = "nextflow",
	callback = function(ev)
		vim.bo[ev.buf].commentstring = "// %s"
	end,
	desc = "Set Nextflow comment style",
})

-- Indentation per filetype: tabstop, shiftwidth and softtabstop all take `width`
-- NOTE: Other filetypes use the global default from config/options.lua (2 spaces). Filetype
-- plugins run before this autocmd, so these values win over theirs (Python's sets tabstop=8).
-- A project's .editorconfig still wins over both, Neovim applies it after FileType autocmds
-- HELP: :help 'shiftwidth', :help ft-python-plugin, :help editorconfig
local indent_by_filetype = {
	lua = { width = 2, spaces = false }, -- real tabs shown 2 wide, like the stylua-formatted files
	sh = { width = 2, spaces = true },
	bash = { width = 2, spaces = true },
	r = { width = 2, spaces = true },
	python = { width = 4, spaces = true },
	nextflow = { width = 4, spaces = true }, -- nf-core style
}
local filetype_indent_group = vim.api.nvim_create_augroup("FiletypeIndent", {})
vim.api.nvim_create_autocmd("FileType", {
	group = filetype_indent_group,
	pattern = vim.tbl_keys(indent_by_filetype),
	callback = function(ev)
		local indent = indent_by_filetype[ev.match]
		local bo = vim.bo[ev.buf]
		bo.tabstop = indent.width
		bo.shiftwidth = indent.width
		bo.softtabstop = indent.width
		bo.expandtab = indent.spaces
	end,
	desc = "Set indentation per filetype",
})
