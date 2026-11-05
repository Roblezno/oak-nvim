-- ================================================================
-- TITLE: NeoVim Options
-- ABOUT: Leader keys, native editor defaults, persistent undo, folding, and window behavior
-- ================================================================

-- Leader keys: I pick <space> since that's what I'm used to
-- NOTE: Set first, before any keymap that uses <leader> is defined (config/keymaps.lua and
-- plugins/keymaps.lua load after this file)
-- HELP: :help mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Settings
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.wrap = false -- Display long lines without wrapping
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of the cursor when scrolling
-- cmdheight 0 + one global statusline: maximize vertical space. ui2 handles messages (end of file)
vim.opt.cmdheight = 0 -- Hide the command line when it is not in use
vim.opt.laststatus = 3 -- One global statusline for all windows (lualine follows it, see plugins/ui.lua)
vim.opt.spelllang = { "en" }

-- Tabbing / Indentation
-- NOTE: 2 spaces by default (bash, R, YAML, JSON, Markdown...). Python and Nextflow use 4 spaces
-- and Lua uses tabs shown 2 wide, set per filetype in config/autocmds.lua. A project's
-- .editorconfig is applied on top of all of this by Neovim
-- HELP: :help 'expandtab', :help editorconfig
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.grepprg = "rg --vimgrep" -- Use ripgrep if available
vim.opt.grepformat = "%f:%l:%c:%m" -- filename, line number, column, content

-- Search Settings
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase in search
vim.opt.hlsearch = true -- Highlight search matches; <Esc> clears them with :nohlsearch
vim.opt.incsearch = true -- Show matches as you type


-- Visual Settings
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.colorcolumn = "100" -- Show column at x characters
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- Show the matching bracket for 0.2 seconds
vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup menu transparency
-- NOTE: transparent-popups (disabled, see lua/plugins/ui.lua) sets its own border when enabled
vim.opt.winborder = "rounded" -- Rounded borders on every floating window
vim.opt.title = true -- Show the file name in the terminal tab title
-- Tabline: custom one in lua/utils/tabline.lua, colors set on ColorScheme (config/autocmds.lua)
vim.opt.showtabline = 1 -- Only when there are 2 or more tabs
vim.opt.tabline = "%!v:lua.require'utils.tabline'.render()"
vim.opt.fillchars:append({ diff = "╱" }) -- Diagonal lines in empty diff areas
vim.opt.redrawtime = 10000 -- Timeout for syntax highlighting redraw
vim.opt.maxmempattern = 20000 -- Max memory for pattern matching
-- NOTE: The next line could be increased in case I need to search for
-- something in a really long line
vim.opt.synmaxcol = 300 -- Syntax highlighting column limit

-- File Handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't backup before overwriting
vim.opt.swapfile = false -- Don't create swap files
vim.opt.updatetime = 300 -- Time in ms to trigger CursorHold
vim.opt.timeoutlen = 500 -- Time in ms to wait for mapped sequence
vim.opt.ttimeoutlen = 0 -- No wait for key code sequences
vim.opt.autoread = true -- Auto-reload file if changed outside
vim.opt.autowrite = false -- Don't auto-save on some events
vim.opt.diffopt:append("vertical") -- Vertical diff splits
vim.opt.diffopt:append("algorithm:patience") -- Better diff algorithm
vim.opt.diffopt:append("linematch:60") -- Better diff highlighting (smart line matching)

-- Persistent undo: keep edit history when files are reopened (swap files only get in the way).
-- Lives in the cache path (~/.cache/nvim/undodir), which respects XDG_CACHE_HOME and NVIM_APPNAME.
-- HELP: :help undo-persistence, :help stdpath()
vim.opt.undofile = true -- Save history on file write and restore it on file read
local undodir = vim.fn.stdpath("cache") .. "/undodir"
vim.opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p") -- Create the directory and any missing parents
end

-- Behavior Settings
vim.opt.errorbells = false -- Disable error sounds
vim.opt.backspace = "indent,eol,start" -- Make backspace behave naturally
vim.opt.autochdir = false -- Don't change directory automatically
vim.opt.iskeyword:append("-") -- Treat dash as part of a word (kebab-case names, CSS classes)
vim.opt.path:append("**") -- Search into subfolders with `:find` and `gf`
vim.opt.selection = "inclusive" -- Use inclusive selection
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.modifiable = true -- Allow editing buffers
vim.opt.encoding = "UTF-8" -- Use UTF-8 encoding
vim.opt.wildmenu = true -- Enable command-line completion menu
vim.opt.wildmode = "longest:full,full" -- Completion mode for command-line
-- Files skipped by `:` completion, `:find` and glob()
vim.opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
vim.opt.wildignorecase = true -- Case-insensitive tab completion in commands

-- Cursor Settings
vim.opt.guicursor = {
	"n-v-c:block", -- Normal, Visual, Command-line
	"i-ci-ve:block", -- Insert, Command-line Insert, Visual-exclusive
	"r-cr:hor20", -- Replace, Command-line Replace
	"o:hor50", -- Operator-pending
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- All modes: blinking & highlight groups
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch mode
}


-- Filetypes
-- Nextflow: not detected by Neovim. Scripts (.nf) and config files share one filetype, the
-- language server tells them apart by extension. A *.config file counts as Nextflow when a
-- nextflow.config sits in its folder or above (nf-core keeps extra configs in conf/).
-- nf-test.config is excluded (not handled by the language server). Returning nil falls back to
-- Neovim's own .config detection
-- HELP: :help vim.filetype.add()
vim.filetype.add({
	extension = { nf = "nextflow" },
	filename = { ["nextflow.config"] = "nextflow" },
	pattern = {
		[".*%.config"] = function(path)
			if vim.fs.basename(path) ~= "nf-test.config" and vim.fs.root(path, "nextflow.config") then
				return "nextflow"
			end
		end,
	},
})

-- Folding Settings
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Keep all folds open by default

-- Split Behavior
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.splitright = true -- Vertical splits open to the right

-- Session Settings
-- :restart saves and restores the session. Without "blank", scratch windows are not
-- saved, so restoring doesn't try to recreate them.
-- HELP: :help 'sessionoptions', :help :restart
vim.opt.sessionoptions:remove("blank") -- Don't save empty/scratch windows in sessions

-- Diagnostics (LSP errors/warnings)
-- HELP: :help vim.diagnostic.config()
vim.diagnostic.config({
	virtual_text = false, -- Show the message at the end of the line
	severity_sort = true, -- Errors before warnings in signs and floats
})

-- NOTE: LSP hover (K) padding is done by transparent-popups, see lua/plugins/ui.lua

-- Messages: Neovim 0.12's experimental ui2 replaces the message area and the hit-enter prompt
-- - Short messages: popup in a corner, at most 30% of the screen tall, gone after 5 seconds
-- - Long output (errors, :ls, 'verbose', :!cmd, progress): scrollable pager, at most half the
--   screen. q closes it, g< reopens the message history
-- - Search, completion, the `:` completion list and confirm prompts stay in the command line
-- - Output of a command typed in the command line goes there too, whatever its kind: it expands
--   over the bottom of the screen until the next key, and <CR> moves it into the pager
-- NOTE: 0.12 API (nightly moves the timeout to 'messagesopt'). ui2 checks targets[trigger] before
-- targets[kind], so typed_cmd wins over the message kind. Entered searches always go to the
-- command line. The floating `:` box on top of ui2 is tiny-cmdline, see plugins/ui.lua
-- HELP: :help ui-messages, $VIMRUNTIME/lua/vim/_core/ui2.lua
require("vim._core.ui2").enable({
	msg = {
		target = "msg", -- Kinds not listed below
		targets = {
			-- Trigger: a command typed in the command line
			typed_cmd = "cmd",
			-- Kinds that stay in the command line
			search_count = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
			-- Kinds with long output
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_out = "pager",
			shell_err = "pager",
			shell_ret = "pager",
			progress = "pager",
		},
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})

-- END OF BASIC CONFIG OPTS
