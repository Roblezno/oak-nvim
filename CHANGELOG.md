# Changelog
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
