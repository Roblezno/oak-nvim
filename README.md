# oak-nvim

A personal Neovim config focused on bioinformatics: pipeline building with Nextflow, Python
scripting, statistics with R and Quarto Markdown writing (among others).

> **Status:** v0.1.0. The base editor, UI and navigation are set up. Language support (LSP,
> Treesitter parsers, formatters) for the languages above is not configured yet.

## Requirements

- [Neovim](https://neovim.io) **0.12+** (plugins are managed with the built-in `vim.pack`)
- `git`
- A [Nerd Font](https://www.nerdfonts.com), set as your terminal font
- A terminal with true color support
- [`ripgrep`](https://github.com/BurntSushi/ripgrep): Telescope live grep and `:grep`
- `make` and a C compiler (`gcc` or `clang`): builds `telescope-fzf-native`
- Optional: [`fd`](https://github.com/sharkdp/fd) for faster file search in Telescope
- Optional: a clipboard tool (`wl-clipboard` on Wayland, `xclip`/`xsel` on X11) for system
  clipboard support

## Installation

Back up your current config, if you have one:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone the repo and start Neovim:

```sh
git clone <repo-url> ~/.config/nvim
nvim
```

On first launch `vim.pack` asks you to confirm installing the plugins. They are installed at the
revisions recorded in `nvim-pack-lock.json`, and `telescope-fzf-native` is built automatically.

To try it without replacing your config:

```sh
git clone <repo-url> ~/.config/oak-nvim
NVIM_APPNAME=oak-nvim nvim
```

### Updating plugins

Run `:lua vim.pack.update()`, review the changes, then `:write` to apply them or `:quit` to
cancel.

## Features

### Plugins

| Area       | Plugin                                                                | Purpose                            |
| ---------- | --------------------------------------------------------------------- | ---------------------------------- |
| UI         | [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)             | Colorscheme (wave, transparent)    |
| UI         | [alpha-nvim](https://github.com/goolord/alpha-nvim)                   | Start dashboard                    |
| UI         | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)          | Statusline                         |
| UI         | [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)     | Highlight TODO/NOTE/WARNING tags   |
| UI         | [nvim-notify](https://github.com/rcarriga/nvim-notify)                | Notification popups                |
| UI         | [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)     | Animated cursor movement           |
| UI         | [mini.icons](https://github.com/nvim-mini/mini.icons)                 | Icon provider                      |
| Utilities  | [nvim-autopairs](https://github.com/windwp/nvim-autopairs)            | Auto-close brackets and quotes     |
| Utilities  | [which-key.nvim](https://github.com/folke/which-key.nvim)             | Keymap hints                       |
| Navigation | [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)       | File explorer                      |
| Navigation | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)    | Fuzzy finder (with fzf-native)     |
| Navigation | [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)        | Scrollbar                          |

### Editor defaults

- Relative line numbers, cursorline and a column guide at 100
- 2-space indentation with spaces
- Persistent undo, no swap or backup files
- System clipboard integration
- Treesitter-based folding (all folds open by default)
- Restores the last cursor position when reopening a file
- Highlights yanked text

## Structure

```
init.lua              entry point
lua/config/           options, keymaps, autocommands and globals
lua/plugins/          plugin installation and configuration
nvim-pack-lock.json   locked plugin revisions
```

## License

See [LICENSE](LICENSE).
