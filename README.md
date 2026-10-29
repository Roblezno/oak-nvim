# oak-nvim

A personal Neovim config focused on bioinformatics: pipeline building with Nextflow, Python
scripting, statistics with R and Quarto Markdown writing (among others).

> **Status:** v0.3.0. The base editor, UI, navigation, Treesitter (baseline languages), base
LSP and cmp with some utilities and custom theme updates with personal plugins. 
Now implementing Quarto Markdown and related plugins.

## Requirements

- [Neovim](https://neovim.io) **0.12+** (plugins are managed with the built-in `vim.pack`)
- `git`
- A [Nerd Font](https://www.nerdfonts.com), set as your terminal font
- A terminal with true color support
- [`ripgrep`](https://github.com/BurntSushi/ripgrep): Telescope live grep and `:grep`
- `make` and a C compiler (`gcc` or `clang`): builds `telescope-fzf-native` and the Treesitter
  parsers
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter) **0.26.1+** (from your package
  manager, not npm), `tar` and `curl`: install the Treesitter parsers
- `unzip` and `gzip`: Mason extracts the language servers it downloads
- `python3` with the `venv` module: Mason installs the Python language servers (basedpyright,
  ruff) in a virtual environment
- [R](https://www.r-project.org): runs the R language server, whose packages are compiled from
  source on install
- `curl`: blink.cmp downloads its prebuilt fuzzy matcher
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
blink.cmp downloads its prebuilt fuzzy matcher on first load.
The Treesitter parsers are then downloaded and compiled in the background. Files opened before
they finish are not highlighted until you reopen them.

Mason then installs the language servers in the background (`:Mason` shows the progress). The R
server is compiled from source, so it can take several minutes; keep Neovim open until it
finishes.

To try it without replacing your config:

```sh
git clone <repo-url> ~/.config/oak-nvim
NVIM_APPNAME=oak-nvim nvim
```

### Updating plugins

Run `:lua vim.pack.update()`, review the changes, then `:write` to apply them or `:quit` to
cancel. When `nvim-treesitter` is updated, its parsers are updated too (`:TSUpdate`).

## Features

### Plugins

| Area       | Plugin                                                                    | Purpose                            |
| ---------- | ------------------------------------------------------------------------- | ---------------------------------- |
| UI         | [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)                 | Colorscheme (wave, transparent)    |
| UI         | [alpha-nvim](https://github.com/goolord/alpha-nvim)                       | Start dashboard                    |
| UI         | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)              | Statusline                         |
| UI         | [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)         | Highlight TODO/NOTE/WARNING tags   |
| UI         | [nvim-notify](https://github.com/rcarriga/nvim-notify)                    | Notification popups                |
| UI         | [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)         | Animated cursor movement           |
| UI         | [mini.icons](https://github.com/nvim-mini/mini.icons)                     | Icon provider                      |
| UI         | [transparent-popups](https://github.com/Roblezno/nvim-transparent-popups) | Custom themed popups               |
| Utilities  | [nvim-autopairs](https://github.com/windwp/nvim-autopairs)                | Auto-close brackets and quotes     |
| Utilities  | [which-key.nvim](https://github.com/folke/which-key.nvim)                 | Keymap hints                       |
| Navigation | [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)           | File explorer                      |
| Navigation | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)        | Fuzzy finder (with fzf-native)     |
| Navigation | [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)            | Scrollbar                          |
| Treesitter | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)     | Parser installer (`main` branch)   |
| LSP        | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                | Language server configs            |
| LSP        | [mason.nvim](https://github.com/mason-org/mason.nvim)                     | Language server installer          |
| LSP        | [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Installs and enables the servers   |
| Completion | [blink.cmp](https://github.com/saghen/blink.cmp)                          | Completion Menu + cmdline          |
| Completion | [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)      | Snippet collection                 |


## Structure

```
init.lua              entry point
lua/config/           options, keymaps, autocommands and globals
lua/plugins/          plugin installation and configuration
nvim-pack-lock.json   locked plugin revisions
```

## License

See [LICENSE](LICENSE).
