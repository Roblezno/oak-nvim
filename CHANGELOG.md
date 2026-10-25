# Changelog
## 0.2.0-dev


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
