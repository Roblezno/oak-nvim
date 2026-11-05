# Changelog
## 0.5.0-dev
### Implemented
- Messages through Neovim 0.12's experimental ui2, enabled at the end of config/options.lua.
Short messages show in a corner popup (at most 30% of the screen, gone after 5 seconds). Errors,
list output (:ls), 'verbose', :!cmd output and progress go to a scrollable pager (at most half
the screen). Search, completion, the `:` completion list and confirm prompts stay in the
command line, and so does the output of a typed command: it expands until the next key, <CR>
moves it into the pager.
- tiny-cmdline.nvim (https://github.com/rachartier/tiny-cmdline.nvim) in ui.lua: the `:` command
line as a floating box, centered left to right and 20% from the top. blink.cmp's cmdline menu
follows it.
- Only the active window shows the cursorline (WinLeave/WinEnter autocmds). Windows that keep
it off, like pickers and popups, are left alone.
- Core keymaps in config/keymaps.lua: `x`, `<leader>d` and `<leader>c` delete/change without
copying, `<leader>p` pastes the last yank, `dw` deletes the word backwards without copying,
`+`/`-` increment/decrement, `te` opens a new tab (`:tabedit`), and
`<leader>o`/`<leader>O` open a line below/above without continuing the comment.
- `<leader>bd` closes every hidden buffer except unsaved ones, and says how many it closed and
kept. Only listed file buffers count: terminals, help and plugin buffers are left alone. The
helper lives in lua/utils/editor.lua (`require("utils").editor`).
- Custom tabline without a plugin (lua/utils/tabline.lua), shown only with 2 or more tabs. Each
tab is a trapezoid with the icon and file name of its active window, padded with 3 spaces:
bold base4 on yellow when active, base0 on base02 otherwise (solarized-osaka palette, with a
TabLine/TabLineSel fallback for other colorschemes). Names over 20 characters are cut to 17 plus
`…`, unsaved tabs show `[+]`, terminals and empty buffers show `[Terminal]`/`[No Name]`. Tabs
can be clicked.
- incline.nvim (https://github.com/b0o/incline.nvim) in ui.lua: a file name tag with its icon in
the top-right corner of each window, plus `[+]` when unsaved, so each split says which file it
holds with one global statusline. The tag hides when the cursor reaches its line.
- snacks.nvim (https://github.com/folke/snacks.nvim) in ui.lua, set up right after the icons:
notifier (replaces nvim-notify), indent guides, statuscolumn, words (the word under the cursor is
highlighted everywhere through the language server, `]]`/`[[` jump between the references) and
image (the image under the cursor in `.md`/`.qmd` shows in a popup, replaces image.nvim). Smooth
scroll stays off. In Python and Markdown/Quarto buffers their own `]]`/`[[` keep winning.
- oil.nvim (https://github.com/stevearc/oil.nvim) in navigation.lua: the file explorer, replacing
neo-tree (nui.nvim goes with it) and netrw. Directories are buffers, so files are renamed, moved
and deleted by editing the text and saving. Shows hidden files and the icon, permissions, size
and modified time columns. Renaming a file asks the language server to update imports and saves
those edits. `<leader>e` opens it as a centered float with a live preview (at most 200 columns,
rounded corners), `h` goes to the parent directory and `q` closes it. In the tabline an oil tab
shows its directory with no icon, cut from the left to `…` plus the last 17 characters.
- nvim-highlight-colors (https://github.com/brenoprata10/nvim-highlight-colors) in ui.lua: hex,
rgb, hsl, ANSI and CSS variable colors are painted as backgrounds. Tailwind and named colors stay
off. Neovim's LSP document colors are turned off (LspAttach autocmd), so colors aren't painted
twice.
- conform.nvim (https://github.com/stevearc/conform.nvim) in lsp.lua: formats on save with a
1000 ms timeout, falling back to the language server. Web files, markdown and yaml use oxfmt,
prettierd or prettier (the first available), and oxfmt only runs in projects with an oxfmt config.
Lua uses stylua, sh uses shfmt, fish uses fish_indent and Python uses ruff. R and Nextflow aren't
formatted on save. `:ToggleFormatter` turns it off or back on for the current buffer.
- gitsigns.nvim (https://github.com/lewis6991/gitsigns.nvim) in the new plugins/git.lua, with its
defaults. `<leader>gb` blames the line and `<leader>gB` the buffer. `<leader>go` opens the file as
of the commit that last touched the line, in a new tab. `<leader>gs` stages the buffer, or
unstages it if nothing is left to stage, and `<leader>gh` stages or unstages the hunk.
- mini.diff in git.lua, from craftzdog's fork (https://github.com/craftzdog/mini.diff, branch
`feat/grouping`), for its overlay that groups changes into whole hunks, the way `git diff` shows
them. `<leader>gd` toggles it and `]c`/`[c` jump between hunks. gitsigns keeps the signs and
staging, so mini.diff's own mappings are off.
- codediff.nvim (https://github.com/esmuellert/codediff.nvim) in git.lua for side-by-side diffs
and history. The explorer is a tree 50 columns wide that opens files as the cursor moves and shows
+/- line stats. Compact mode shows only the changes plus 8 context lines, with folds synced across
panes. `<leader>gv` toggles the diff view, `<leader>gl` shows the current file's history and
`<leader>gL` the repo history.
- Lazygit through snacks.nvim: `;g` opens it in a float, with the theme synced and the active
border in the `WarningMsg` color. `e` on a file closes lazygit and opens the file in the window
it was launched from, not a new tab or a nested Neovim. The edit command works in fish, zsh and
bash, since lazygit runs it with `$SHELL`.
- config/commands.lua (user commands) and config/workarounds.lua (temporary bug fixes, empty for
now).
- lua/utils/init.lua: returns the table of shared helper modules, empty for now.

### Changed
- New config layout. init.lua enables vim.loader, loads config.options, config.keymaps,
config.autocmds, config.commands and config.workarounds, then plugins.
- plugins/init.lua installs every plugin in a single vim.pack.add() call, then requires each
group file (ui, utilities, navigation, treesitter, lsp, completion, markdown). Group files only
configure their plugins.
- Keymaps that use a plugin moved from config/keymaps.lua to plugins/keymaps.lua, required last
so every plugin is set up first. config/keymaps.lua keeps the plain Neovim keymaps.
- Leader keys moved from config/globals.lua to the top of config/options.lua.
- Lua files are indented with tabs and use double quotes (stylua defaults).
- transparent-popups is disabled: its spec and setup are commented out.
- Indentation per filetype (FileType autocmd in config/autocmds.lua): Python and Nextflow use 4
spaces, Lua uses tabs shown 2 wide (like the stylua-formatted files), bash and R use 2 spaces.
Other filetypes keep the global default of 2 spaces. A project's .editorconfig still wins.
- `-` counts as part of a word (iskeyword), so kebab-case names and CSS classes are one word.
- More vertical space: cmdheight 0 and one global statusline (laststatus 3). lualine's
globalstatus follows laststatus, otherwise it would reset it to 2.
- Rounded borders on every float (winborder), the file name in the terminal tab title (title),
and a diagonal `╱` fill in empty diff areas (fillchars).
- Persistent undo moved from ~/.local/share/nvim/undodir to ~/.cache/nvim/undodir.
- `:` completion and `:find` skip node_modules/ and build artifacts (*.o, *.obj, *.pyc, *.class,
*.jar) through wildignore.
- Splits moved from `<leader>wsh`/`<leader>wsv` to `ss`/`sv`.
- Colorscheme: solarized-osaka (https://github.com/craftzdog/solarized-osaka.nvim), vivid
style, transparent background. lualine uses the `auto` theme.
- mini.icons is the one icon source: it mocks nvim-web-devicons, so plugins that only know
devicons (telescope, lualine) use it too. Set up right after the colorscheme.
- lualine sections: mode | git branch | project root name (only when it differs from the cwd),
filetype icon and a short path | macro recording register, diagnostics, git diff counts |
progress | line:column. The root is the nearest folder upward with `.git`, `lua`,
`package.json`, `Makefile`, `Cargo.toml`, `go.mod` or `pyproject.toml`. The bar also refreshes
when a macro starts or stops, so the recording indicator replaces the hidden command line.
- Treesitter installs 39 parsers instead of 6, adding the web, systems and tooling languages. A
FileType autocmd now starts highlighting and indentation for every filetype with a parser,
instead of a fixed list. Languages without indent queries keep their filetype's own indentation.
- Language servers: mason-tool-installer.nvim
(https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) replaces mason-lspconfig.nvim. It
installs the server and formatter list on start and never updates it. Servers are turned on with
one `vim.lsp.enable()` list, so only listed servers start: pyright and vimls no longer do, even
when installed in Mason. New servers: vtsls, eslint, oxlint, tailwindcss, cssls and rust_analyzer.
nextflow_ls, which only ran because it was in Mason, is now on both lists. Every server gets
file-rename support.
- Diagnostics: inline text is on, as `● message`, with the source only when a buffer has several.
`<leader>ti` toggles it. Underlined, not updated while typing and sorted by severity. Gutter icons
come from the new shared icon set (lua/utils/icons.lua, `require("utils").icons`).
- Per-server LSP settings moved from plugins/lsp.lua to after/lsp/<name>.lua, which Neovim merges
on top of the nvim-lspconfig defaults. vtsls uses the workspace TypeScript, updates imports on
file move, and adds server-side fuzzy matching, function-call completion and short inlay hints.
lua_ls adds parameter type hints and silences the missing-fields and trailing-space checks.
cssls ignores empty rules. `<leader>th` toggles inlay hints, which stay off by default.
- Completion: blink.cmp moved to the `enter` preset, so `<CR>` accepts instead of `<C-y>`.
Brackets are added after functions, docs show after 200 ms, language server items are colorized
by Treesitter and kind icons come from the shared icon set. Ghost text stays off. In the command
line nothing is preselected, so `<CR>` runs what was typed and `<Tab>` still accepts.
- mini.pairs (https://github.com/nvim-mini/mini.pairs) replaces nvim-autopairs, with its defaults,
in insert and command mode.
- LSP keymaps: `gd`, `gy`, `gr` and `;c` (incoming calls) go through Telescope. `gD` goes to the
declaration, `gI` to the source definition in TypeScript (skipping `.d.ts` files) and the
implementation elsewhere, `gK` and `<C-k>` in insert mode show signature help. `<leader>lca` code
actions, `<leader>lcr` rename, `<leader>lcR` rename the file with import updates, `<leader>lcf`
format now and `<leader>lcl` LSP info. `]d` and `[d` show the diagnostic in a float. These replace
`<leader>lf`, `lr`, `la`, `li`, `lR` and `lt`.

### Removed
- config/globals.lua (merged into config/options.lua).
- kanagawa.nvim, replaced by solarized-osaka.nvim.
- nvim-web-devicons, replaced by the mini.icons mock.
- nvim-notify, replaced by the snacks notifier. `<leader>nd`/`<leader>nh` (dismiss, history) now
use it.
- image.nvim, replaced by snacks.image (same popup at the cursor). img-clip stays for pasting.

## 0.4.0
### Implemented
- Running code with vim-slime (https://github.com/jpalardy/vim-slime) in utilities.lua. Code is
sent to a REPL (R, IPython, bash...) in the last active tmux pane, with bracketed paste and no
prompt on the first send. It replaces molten-nvim for .qmd chunks and also works in plain
scripts.
- Run/REPL keymaps under <leader>r: <leader>rc/ra/rA run the cell/cell and above/all cells of a
.qmd (quarto runner), <leader>rl/rp send the line/paragraph, <leader>rr sends the visual
selection and <leader>rs picks another tmux pane.
- Nextflow filetype detection in options.lua: .nf files, nextflow.config, and *.config files
with a nextflow.config in their folder or above (nf-test.config excluded). Nextflow buffers use
`// %s` comments, so `gc` works.
- Diagnostic toggles: <leader>td turns diagnostics on/off, <leader>tu toggles only the
underlines (signs stay).
- nvim-notify keymaps: <leader>nd dismisses the popups, <leader>nh opens the notification
history.

### Changed
- quarto-nvim's code runner sends chunks to vim-slime (default_method = "slime").
- img-clip.nvim and image.nvim moved from markdown.lua to utilities.lua. image.nvim is only used
for the image link popup in .md and .qmd files, with its default image sizes.

### Removed
- molten-nvim and its setup: the <leader>j keymaps, the PackChanged autocmd running
:UpdateRemotePlugins, python3_host_prog and the `neovim` conda env. Jupyter kernels are no
longer needed to run code chunks.

## 0.3.1
### Implemented
- Image support in markdown.lua with image.nvim (https://github.com/3rd/image.nvim), using the
kitty graphics protocol (Ghostty) and the ImageMagick CLI. In .md and .qmd files the image link
under the cursor is shown in a popup. smear-cursor and notify floats are ignored by its overlap
clearing, otherwise they hide molten's plots.
- Running Quarto code chunks with molten-nvim (https://github.com/benlubas/molten-nvim), pinned
to the 1.* releases. Chunks run in Jupyter kernels and their output (text and plots, through
image.nvim) is shown under each chunk. Molten's Python dependencies live in a dedicated `neovim`
conda env, set as python3_host_prog in options.lua when it exists. Kernels are registered per
project conda env: <env> for Python, <env>-r for R, plus bash.
- :UpdateRemotePlugins runs through a PackChanged autocmd when molten-nvim is installed or
updated, so its commands are registered after a restart.
- Molten and quarto runner keymaps under <leader>j: <leader>ji starts the kernel named after the
active conda env (or opens the picker), <leader>jI opens the picker, <leader>jc/ja/jA/jl run the
cell/cell and above/all cells/line, <leader>jr runs the visual selection, <leader>jo enters the
output window, <leader>jh/jd hide/delete the output, <leader>jx/jR/jq interrupt/restart/stop the
kernel and <leader>jb opens HTML output in the browser.
- README documents the molten setup (conda env, kernel registration, Jupyter runtime folder, tmux
options) and its new requirements (Miniforge, ImageMagick, a terminal with the kitty graphics
protocol).

### Changed
- quarto-nvim's code runner is enabled and sends chunks to molten (default_method = "molten").
- The R language server is no longer installed by Mason. It runs nvim-lspconfig's default command
(R -e "languageserver::run()") with the R on PATH and is enabled in lsp.lua, excluded from
mason-lspconfig's automatic_enable. languageserver must be installed in each R (the system R and
each conda env), see the README.

### Fixed
- r_language_server crashed inside conda envs with another R (rlang.so: undefined symbol
R_MakeMissingBinding): Mason builds its library with the R on PATH at install time, but its
wrapper runs the R on PATH at run time. The server now always runs with the R that installed
languageserver: the active conda env's R and packages, or the system R.
- R files outside a git repository got the home folder as workspace root (nvim-lspconfig's
fallback), so languageserver indexed every R file under it (conda envs included) and stopped
answering. They now run without a workspace root (single-file mode).
- R chunks in .qmd files showed "Failed to run diagnostics" (normalizePath(): No such file or
directory) for <file>.qmd.otter.R. otter's hidden buffers only existed in memory, and lintr's
object_length, object_name and object_usage linters need the file on disk. otter now writes
its buffers to disk (buffers.write_to_disk = true) and deletes them on quit or when the main
buffer is closed.

## 0.3.0
### Implemented
- Quarto (.qmd) highlighting and folding: the markdown Treesitter parser is registered for the
quarto filetype. Code chunks and the YAML header are highlighted through the markdown queries
bundled with Neovim.
- Quarto support in markdown.lua with quarto-nvim (https://github.com/quarto-dev/quarto-nvim)
and otter.nvim (https://github.com/jmbuhr/otter.nvim). Python and R code chunks get LSP features
(completion, hover, diagnostics on save) through otter. <leader>mp opens the browser preview
(quarto preview, also for .md files) and <leader>mq closes it.
- marksman (https://github.com/artempyanykh/marksman) language server for .md files, installed
by Mason.
- Pasting clipboard images with img-clip.nvim (https://github.com/HakonHarnes/img-clip.nvim).
<leader>mi saves the image in an assets/ folder next to the current file and inserts the
markdown link.
- README documents the markdown and Quarto setup and its new requirements (Quarto CLI,
wl-clipboard or xclip for pasting images).
- bashls (bash-language-server), installed by Mason, for bash files. Bash code chunks in .qmd get
LSP features through otter too.

### Changed
- r_language_server no longer attaches to quarto buffers. R chunks in .qmd go through otter, so
completions and diagnostics are not duplicated.

### Fixed
- The Trouble keymap (<leader>tx) had its description inside the command string, so extra keys
were typed after opening Trouble. The description is now in the keymap options.

## 0.2.3
- Replacing the manual steps in 0.2.2 with a custom plugin: https://github.com/Roblezno/nvim-transparent-popups.

## 0.2.2
- LSP hover and blink completion menu now match Kanagawa-wave theme, have transparency,
border and rignt-left padding.

## 0.2.1
### Implemented
- LSP diagnostics wired through trouble plugin (https://github.com/folke/trouble.nvim). <leader>tx
to access the trouble diagnostics buffer.

### Changed
- Inline diagnostics hidden. Only diagnostics hints remain. Messages are displayed in trouble buffer
- Remapped LSP keymaps from g<r,n,t...> to <leader>l<r,n,t...>

### Fixed
- Telescope find recent files option was not defined. Now accesed by <leader>fr

## 0.2.0
### Implemented
- LSP support in lsp.lua with nvim-lspconfig (https://github.com/neovim/nvim-lspconfig),
mason.nvim (https://github.com/mason-org/mason.nvim) and mason-lspconfig.nvim
(https://github.com/mason-org/mason-lspconfig.nvim). Mason installs lua_ls, basedpyright,
ruff and r_language_server, and mason-lspconfig enables them (vim.lsp.enable). lua_ls is
set up to recognise the Neovim runtime.
- Ruff hover is disabled through a LspAttach autocmd, so K shows basedpyright's type
information in Python files.
- Diagnostics are shown at the end of the line (vim.diagnostic.config in options.lua).
- LSP keymaps gd (go to definition) and <leader>lf (format). The rest are Neovim defaults
(K, grn, gra, grr, gri, grt, gO, ]d, [d).
- README documents the LSP setup and its new requirements (unzip, gzip, python3 with venv, R).
- Completion support in completion.lua with blink.cmp (https://github.com/saghen/blink.cmp)
and friendly-snippets (https://github.com/rafamadriz/friendly-snippets). blink.cmp is pinned
to the 1.* releases, so its prebuilt fuzzy matcher is downloaded automatically. Sources are
LSP, path, snippets and buffer, with the default keymap preset (<C-y> accept, <C-n>/<C-p>
navigate, <C-space> open menu/docs, <C-e> hide). blink.cmp registers its LSP capabilities
itself, so lsp.lua is unchanged.
- README documents the completion setup and that blink.cmp needs curl.

## 0.1.2
### Fixed
- nvim-notify was installed but not wired into Neovim's notification system
(vim.notify). Now it is set as the notification handler.

### Implemented
- Plugin lua file headers documenting all the plugin in that file so
it is easier to see what's going on in said file.
- Treesitter support with nvim-treesitter, main branch (https://github.com/nvim-treesitter/nvim-treesitter),
in treesitter.lua. It installs the parsers for Python, R, Bash, YAML, TOML and JSON.
Highlighting is started by Neovim through a FileType autocmd, and the parsers are updated
with :TSUpdate whenever the plugin is updated (PackChanged autocmd).

## 0.1.1
### Fixed
- Saving a session in nvim (:restart does that) is controlled by
sessionoptions. The default includes "blank", meaning windows holding a
nofile (buffers that are not files, like NeoTree) get saved too. On
restore, the session tries to recreate the Neotree buffer. Neo-tree then
tries to give its own buffer the same name, and Neovim refuses with E95. 
Removing "blank" from sessionoptions fixes the issue.

### Implemented
-Tmux-navigation plugin (https://github.com/christoomey/vim-tmux-navigator) for integrating
tmux pane navigation with nvim.


## 0.1.0

### Initial baseline config

- Neovim structure defined
- Basic globals, keymaps, autocmds and options ready
- UI plugins installedi in ui.lua (kanagawa-wave theme, alpha nvim dashboard,
lualine, todo comments, notify, smear cursor, mini.icons)
- Quality of Life plugins under utilities.lua (nvim-autopairs and which-key)
- navigation basic plugins (NeoTree, Scrollbar, Telescope)
