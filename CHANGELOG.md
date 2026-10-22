# Changelog
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
