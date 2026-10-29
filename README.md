# oak-nvim

A personal Neovim config focused on bioinformatics: pipeline building with Nextflow, Python
scripting, statistics with R and Quarto Markdown writing (among others).

> **Status:** v0.3.1. The base editor, UI, navigation, Treesitter (baseline languages), base
LSP and cmp with some utilities and custom theme updates with personal plugins. 
Now implementing Quarto markdown related plugins, molten for running code blocks and
img visualization in kitty based terms.

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
  clipboard support. Pasting images (img-clip) needs `wl-clipboard` or `xclip` (`xsel` is not
  supported)
- Optional: the [Quarto CLI](https://quarto.org) for the browser preview of `.qmd` and `.md`
  files
- Optional, to run code chunks and show images:
  [Miniforge](https://github.com/conda-forge/miniforge) (conda/mamba in `~/miniforge3`),
  ImageMagick (`magick`) and a terminal with the kitty graphics protocol (Ghostty, kitty). See
  [Running code chunks](#running-code-chunks-molten)

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
cancel. When `nvim-treesitter` is updated, its parsers are updated too (`:TSUpdate`). When
`molten-nvim` is updated, `:UpdateRemotePlugins` runs too; restart Neovim afterwards.

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
| Markdown   | [quarto-nvim](https://github.com/quarto-dev/quarto-nvim)                  | Quarto preview, LSP in code chunks |
| Markdown   | [otter.nvim](https://github.com/jmbuhr/otter.nvim)                        | LSP backend for code chunks        |
| Markdown   | [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)             | Paste clipboard images             |
| Markdown   | [image.nvim](https://github.com/3rd/image.nvim)                           | Image popups and plot outputs      |
| Markdown   | [molten-nvim](https://github.com/benlubas/molten-nvim)                    | Run code chunks in Jupyter kernels |

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
  (image.nvim).

### Running code chunks (molten)

Code chunks in `.qmd` files run in Jupyter kernels through molten, and their output (text and
plots) is shown under each chunk. Molten runs from a dedicated `neovim` conda env, so it works
whichever env is active. Each project env runs its own kernel, so chunks see that env's packages.

One-time setup:

```sh
mamba create -n neovim -c conda-forge python=3.12 pynvim jupyter_client cairosvg pyperclip bash_kernel
mamba run -n neovim python -m bash_kernel.install --user   # kernel "bash"
mkdir -p ~/.local/share/jupyter/runtime                     # jupyter_client does not create it
```

For each project env, register a kernel named after the env (`<env>` for Python, `<env>-r` for
R):

```sh
# Python
mamba install -n <env> -c conda-forge ipykernel
mamba run -n <env> python -m ipykernel install --user --name <env> --display-name "Python (<env>)"

# R (installspec needs jupyter on PATH, taken from the neovim env)
mamba install -n <env> -c conda-forge r-irkernel
env PATH="$HOME/miniforge3/envs/neovim/bin:$PATH" mamba run -n <env> \
  R -q -e "IRkernel::installspec(name = '<env>-r', displayname = 'R (<env>)')"
```

Inside tmux, add this to `~/.tmux.conf` so images are drawn:

```
set -gq allow-passthrough on
set -g visual-activity off
set-option -g focus-events on
```

After `vim.pack` installs molten on the first launch, restart Neovim once so its commands are
registered. `:checkhealth molten` and `:checkhealth image` check the setup.

- `<leader>ji` starts the kernel named after the active conda env (or opens the picker),
  `<leader>jI` opens the picker to attach another kernel (e.g. R or bash).
- `<leader>jc` / `<leader>ja` / `<leader>jA` / `<leader>jl` run the cell / cell and above / all
  cells / line, `<leader>jr` runs the visual selection.
- `<leader>jo` enters the output window, `<leader>jh` hides the output, `<leader>jd` deletes it.
- `<leader>jx` / `<leader>jR` / `<leader>jq` interrupt / restart / stop the kernel,
  `<leader>jb` opens HTML output in the browser.


## Structure

```
init.lua              entry point
lua/config/           options, keymaps, autocommands and globals
lua/plugins/          plugin installation and configuration
nvim-pack-lock.json   locked plugin revisions
```

## License

See [LICENSE](LICENSE).
