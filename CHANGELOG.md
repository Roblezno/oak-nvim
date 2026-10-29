# Changelog
## 0.3.1-dev (Unreleased)
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

## 0.3.0-dev (Unreleased)
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
