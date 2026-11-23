# oak-nvim

A personal Neovim config focused on bioinformatics: pipeline building with Nextflow, Python
scripting, statistics with R and Quarto Markdown writing (among others).

> **Status:** v0.5.1(Unreleased). The base editor, UI, navigation, Treesitter (baseline languages), base
> LSP and cmp with some utilities and custom theme updates with personal plugins.
> Quarto markdown and Jupyter notebook support, with code sent to a REPL in a tmux pane
> (vim-slime) or to Jupyter kernels (molten).
> Git integration (gitsigns, mini.diff, codediff, lazygit) and format on save (conform).

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
- `npm` (Node.js): Mason installs the bash and web language servers and the JavaScript formatters
- Java 17+: runs the Nextflow language server
- [R](https://www.r-project.org) with the `languageserver` package (compiled from source on
  install): runs the R language server. See [R language server](#r-language-server)
- `curl`: blink.cmp downloads its prebuilt fuzzy matcher
- Optional: [`fd`](https://github.com/sharkdp/fd) for faster file search in Telescope
- Optional: [`lazygit`](https://github.com/jesseduffield/lazygit), opened in a float with `;g`
- Optional: a clipboard tool (`wl-clipboard` on Wayland, `xclip`/`xsel` on X11) for system
  clipboard support. Pasting images (img-clip) needs `wl-clipboard` or `xclip` (`xsel` is not
  supported)
- Optional: the [Quarto CLI](https://quarto.org) for the browser preview of `.qmd` and `.md`
  files
- Optional, to run code: [tmux](https://github.com/tmux/tmux) and a REPL for each language
  (`R` or radian, IPython or Python 3.13+, `bash`). See [Running code](#running-code-vim-slime)
- Optional, for Jupyter notebooks and kernels: [miniforge](https://github.com/conda-forge/miniforge)
  (`mamba`), with a `neovim` env holding the `jupytext` CLI and molten's Python packages. See
  [Jupyter kernels](#jupyter-kernels-molten)
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

On first launch `vim.pack` asks you to confirm installing the plugins, and `telescope-fzf-native` is
built automatically.
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

| Area       | Plugin                                                                                    | Purpose                                  |
| ---------- | ----------------------------------------------------------------------------------------- | ---------------------------------------- |
| UI         | [solarized-osaka.nvim](https://github.com/craftzdog/solarized-osaka.nvim)                 | Colorscheme (transparent)                |
| UI         | [alpha-nvim](https://github.com/goolord/alpha-nvim)                                       | Start dashboard                          |
| UI         | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                              | Statusline                               |
| UI         | [incline.nvim](https://github.com/b0o/incline.nvim)                                       | File name tag on each window             |
| UI         | [tiny-cmdline.nvim](https://github.com/rachartier/tiny-cmdline.nvim)                      | Floating `:` command line (ui2)          |
| UI         | [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                         | Highlight TODO/NOTE/WARNING tags         |
| UI         | [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors)            | Color codes as backgrounds               |
| UI         | [snacks.nvim](https://github.com/folke/snacks.nvim)                                       | Notifier, indent, words, images, lazygit |
| UI         | [mini.icons](https://github.com/nvim-mini/mini.icons)                                     | Icons (stands in for devicons)           |
| UI         | [transparent-popups](https://github.com/Roblezno/nvim-transparent-popups)                 | Custom themed popups                     |
| Utilities  | [mini.pairs](https://github.com/nvim-mini/mini.pairs)                                     | Auto-close brackets and quotes           |
| Utilities  | [which-key.nvim](https://github.com/folke/which-key.nvim)                                 | Keymap hints                             |
| Utilities  | [vim-slime](https://github.com/jpalardy/vim-slime)                                        | Send code to a REPL in tmux              |
| Navigation | [oil.nvim](https://github.com/stevearc/oil.nvim)                                          | File explorer                            |
| Navigation | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                        | Fuzzy finder (with fzf-native)           |
| Navigation | [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)                            | Scrollbar                                |
| Treesitter | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                     | Parser installer (`main` branch)         |
| LSP        | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                | Language server configs                  |
| LSP        | [mason.nvim](https://github.com/mason-org/mason.nvim)                                     | Language server and tool installer       |
| LSP        | [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Installs the tool list on start          |
| Formatting | [conform.nvim](https://github.com/stevearc/conform.nvim)                                  | Format on save                           |
| Completion | [blink.cmp](https://github.com/saghen/blink.cmp)                                          | Completion Menu + cmdline                |
| Git        | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                               | Git signs, blame and staging             |
| Git        | [mini.diff](https://github.com/craftzdog/mini.diff/tree/feat/grouping)                    | Diff overlay, grouped by hunk            |
| Git        | [codediff.nvim](https://github.com/esmuellert/codediff.nvim)                              | Side-by-side diffs and history           |
| Completion | [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)                      | Snippet collection                       |
| Markdown   | [quarto-nvim](https://github.com/quarto-dev/quarto-nvim)                                  | Quarto preview, LSP in code chunks       |
| Markdown   | [otter.nvim](https://github.com/jmbuhr/otter.nvim)                                        | LSP backend for code chunks              |
| Markdown   | [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)                             | Paste clipboard images                   |
| Markdown   | [jupytext.nvim](https://github.com/goerz/jupytext.nvim)                                   | Open .ipynb notebooks as text            |
| Markdown   | [molten-nvim](https://github.com/benlubas/molten-nvim)                                    | Run cells in Jupyter kernels             |

### Markdown and Quarto

- `.qmd` files are highlighted and folded with the markdown Treesitter parser, including the
  code chunks and the YAML header.
- Python and R code chunks in `.qmd` and `.ipynb` get completion, hover and diagnostics through
  otter (diagnostics refresh on save).
- `.ipynb` notebooks open as markdown text (jupytext.nvim) and work like `.qmd` files. Saving
  writes the `.ipynb` back and keeps the outputs already stored in it. Needs the `jupytext` CLI,
  from the `neovim` env (see [Jupyter kernels](#jupyter-kernels-molten)) or on PATH. oil doesn't
  preview notebooks, so browsing them stays fast.
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
  `.qmd` or `.ipynb` (quarto runner, only cells in the same language as the current one). Once
  the buffer has a Jupyter kernel, they run in it instead, see
  [Jupyter kernels](#jupyter-kernels-molten).
- `<leader>rl` sends the line (`3<leader>rl` sends three), `<leader>rp` the paragraph and
  `<leader>rr` the visual selection. These work in any file (`.R`, `.py`, `.sh`, `.qmd`).
- Code is sent with bracketed paste, so Python indentation survives. Use IPython or Python 3.13+,
  older `python` REPLs do not support it.

### Jupyter kernels (molten)

Cells of a `.qmd` or `.ipynb` can also run in a Jupyter kernel through
[molten](https://github.com/benlubas/molten-nvim). Once a buffer has a kernel, the cell keymaps
(`<leader>rc` / `<leader>ra` / `<leader>rA`) send its cells there instead of to the tmux pane, and
stopping the kernel switches them back. Text output is shown under each cell (up to 4 lines) and
plots open in the system image viewer: nothing is drawn in the terminal, so the buffer stays fast.
molten's outputs are not written into the `.ipynb`.

Molten runs from a dedicated `neovim` conda env, so it works whichever env is active. Each project
env runs its own kernel, so cells see that env's packages.

One-time setup:

```sh
mamba create -n neovim -c conda-forge python=3.12 pynvim jupyter_client pillow jupytext bash_kernel
mamba run -n neovim python -m bash_kernel.install --user   # kernel "bash"
mkdir -p ~/.local/share/jupyter/runtime                     # jupyter_client does not create it
```

For each project env, register a kernel named after the env (`<env>` for Python, `<env>-r` for
R). Keep the `-r` suffix: a kernel with the same name overwrites the other one:

```sh
# Python
mamba install -n <env> -c conda-forge ipykernel
mamba run -n <env> python -m ipykernel install --user --name <env> --display-name "Python (<env>)"

# R (installspec needs jupyter on PATH, taken from the neovim env)
mamba install -n <env> -c conda-forge r-irkernel
env PATH="$HOME/miniforge3/envs/neovim/bin:$PATH" mamba run -n <env> \
  R -q -e "IRkernel::installspec(name = '<env>-r', displayname = 'R (<env>)')"
```

After `vim.pack` installs molten on the first launch, restart Neovim once so its commands are
registered. If the `neovim` env was created after that first launch, molten's commands are missing
(`E117: Unknown function: MoltenAvailableKernels`): run `:UpdateRemotePlugins` and restart Neovim.
`:checkhealth molten` and `:checkhealth provider` check the setup.

- `<leader>ji` starts the kernel named after the active conda env (or opens the picker),
  `<leader>jI` opens the picker to attach another kernel (e.g. R or bash).
- `<leader>jo` enters the output window, `<leader>jh` hides the output, `<leader>jd` deletes it.
- `<leader>jx` / `<leader>jR` / `<leader>jq` interrupt / restart / stop the kernel,
  `<leader>jb` opens HTML output in the browser.
- With two or more kernels in one buffer (e.g. Python and R in a `.qmd`), molten asks which one
  runs each cell.

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
nvim-pack-lock.json   locked plugin revisions (created locally, not tracked)
```

## License

See [LICENSE](LICENSE).
