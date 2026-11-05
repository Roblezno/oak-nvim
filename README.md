# oak-nvim

A personal Neovim config focused on bioinformatics: pipeline building with Nextflow, Python
scripting, statistics with R and Quarto Markdown writing (among others).

> **Status:** v0.4.1(Unreleased). The base editor, UI, navigation, Treesitter (baseline languages), base
LSP and cmp with some utilities and custom theme updates with personal plugins. 
Quarto markdown support, with code sent to a REPL in a tmux pane (vim-slime).
Currently implementing a refactor for core functionallities in v0.5.0


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
- [R](https://www.r-project.org) with the `languageserver` package (compiled from source on
  install): runs the R language server. See [R language server](#r-language-server)
- `curl`: blink.cmp downloads its prebuilt fuzzy matcher
- Optional: [`fd`](https://github.com/sharkdp/fd) for faster file search in Telescope
- Optional: a clipboard tool (`wl-clipboard` on Wayland, `xclip`/`xsel` on X11) for system
  clipboard support. Pasting images (img-clip) needs `wl-clipboard` or `xclip` (`xsel` is not
  supported)
- Optional: the [Quarto CLI](https://quarto.org) for the browser preview of `.qmd` and `.md`
  files
- Optional, to run code: [tmux](https://github.com/tmux/tmux) and a REPL for each language
  (`R` or radian, IPython or Python 3.13+, `bash`). See [Running code](#running-code-vim-slime)
- Optional, for image popups: ImageMagick (`magick`) and a terminal with the kitty graphics
  protocol (Ghostty, kitty). Inside tmux it needs the options shown in
  [Markdown and Quarto](#markdown-and-quarto)

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
language server is installed separately, see [R language server](#r-language-server).

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
| UI         | [solarized-osaka.nvim](https://github.com/craftzdog/solarized-osaka.nvim) | Colorscheme (vivid, transparent)   |
| UI         | [alpha-nvim](https://github.com/goolord/alpha-nvim)                       | Start dashboard                    |
| UI         | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)              | Statusline                         |
| UI         | [incline.nvim](https://github.com/b0o/incline.nvim)                       | File name tag on each window       |
| UI         | [tiny-cmdline.nvim](https://github.com/rachartier/tiny-cmdline.nvim)      | Floating `:` command line (ui2)    |
| UI         | [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)         | Highlight TODO/NOTE/WARNING tags   |
| UI         | [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) | Color codes as backgrounds         |
| UI         | [snacks.nvim](https://github.com/folke/snacks.nvim)                       | Notifier, indent, words, images    |
| UI         | [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)         | Animated cursor movement           |
| UI         | [mini.icons](https://github.com/nvim-mini/mini.icons)                     | Icons (stands in for devicons)     |
| UI         | [transparent-popups](https://github.com/Roblezno/nvim-transparent-popups) | Custom themed popups               |
| Utilities  | [nvim-autopairs](https://github.com/windwp/nvim-autopairs)                | Auto-close brackets and quotes     |
| Utilities  | [which-key.nvim](https://github.com/folke/which-key.nvim)                 | Keymap hints                       |
| Utilities  | [vim-slime](https://github.com/jpalardy/vim-slime)                        | Send code to a REPL in tmux        |
| Navigation | [oil.nvim](https://github.com/stevearc/oil.nvim)                          | File explorer                      |
| Navigation | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)        | Fuzzy finder (with fzf-native)     |
| Navigation | [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)            | Scrollbar                          |
| Treesitter | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)     | Parser installer (`main` branch)   |
| LSP        | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                | Language server configs            |
| LSP        | [mason.nvim](https://github.com/mason-org/mason.nvim)                     | Language server installer          |
| LSP        | [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Installs and enables the servers   |
| Completion | [blink.cmp](https://github.com/saghen/blink.cmp)                          | Completion Menu + cmdline          |
| Completion | [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)      | Snippet collection                 |
| Markdown   | [quarto-nvim](https://github.com/quarto-dev/quarto-nvim)                  | Quarto preview, LSP in code chunks |
| Markdown   | [otter.nvim](https://github.com/jmbuhr/otter.nvim)                        | LSP backend for code chunks        |
| Markdown   | [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)             | Paste clipboard images             |

### Markdown and Quarto

- `.qmd` files are highlighted and folded with the markdown Treesitter parser, including the
  code chunks and the YAML header.
- Python and R code chunks in `.qmd` get completion, hover and diagnostics through otter
  (diagnostics refresh on save).
- `.md` files use the [marksman](https://github.com/artempyanykh/marksman) language server
  (installed by Mason): link and heading completion, go to linked files.
- `<leader>mp` opens the browser preview (`quarto preview`, also for `.md`), `<leader>mq` closes
  it.
- `<leader>mi` saves the clipboard image in an `assets/` folder next to the current file and
  inserts the markdown link.
- With the cursor on an image link in `.md` or `.qmd`, the image is shown in a popup
  (snacks.image, `:checkhealth snacks` checks the setup). Inside tmux, add this to `~/.tmux.conf`
  so images are drawn:

  ```
  set -gq allow-passthrough on
  set -g visual-activity off
  set-option -g focus-events on
  ```

### Running code (vim-slime)

Code is sent with [vim-slime](https://github.com/jpalardy/vim-slime) to a REPL running in another
tmux pane: open a split next to Neovim and start `R`, `ipython` or `bash` in it. Code goes to the
last active pane (`{last}`) without asking, `<leader>rs` picks another one. Start the REPL inside
the conda env you need, so it sees that env's packages.

- `<leader>rc` / `<leader>ra` / `<leader>rA` run the cell / cell and above / all cells of a
  `.qmd` (quarto runner, only cells in the same language as the current one).
- `<leader>rl` sends the line (`3<leader>rl` sends three), `<leader>rp` the paragraph and
  `<leader>rr` the visual selection. These work in any file (`.R`, `.py`, `.sh`, `.qmd`).
- Code is sent with bracketed paste, so Python indentation survives. Use IPython or Python 3.13+,
  older `python` REPLs do not support it.

### R language server

The R language server ([languageserver](https://github.com/REditorSupport/languageserver)) runs
with the `R` on your PATH, so it always uses the R that installed it: inside an activated conda
env it runs the env's R and sees its packages, outside it runs the system R. It is not installed
by Mason, which compiles it for a single R, and it crashes when another R runs it.

Install `languageserver` in each R you use. For the system R, run
`install.packages("languageserver")` in an R session started outside conda (once per device).
For each conda env with R:

```sh
mamba install -n <env> -c conda-forge r-languageserver
```

- Activate the conda env before starting Neovim: the server uses the R on PATH at that moment.
- After a minor R upgrade (e.g. 4.6 to 4.7), install `languageserver` again.
- Older setups can remove Mason's copy with `:MasonUninstall r-languageserver`.


## Structure

```
init.lua              entry point
lua/config/           plain Neovim settings: options, keymaps, autocommands, commands, workarounds
lua/plugins/          init.lua installs every plugin, one file per group configures them,
                      keymaps.lua holds the keymaps that use a plugin
lua/utils/            shared helper modules
nvim-pack-lock.json   locked plugin revisions
```

## License

See [LICENSE](LICENSE).
