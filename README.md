# Dotfiles

Personal configs for shell (Bash, Zsh), Git, editors (Neovim, Vim), and tmux. Installed via `install.sh`, which symlinks tracked files into `$HOME`.

## Install

```bash
./install.sh                 # everything
./install.sh bash git        # selected categories
./install.sh --list          # show categories
./install.sh --force         # repoint symlinks owned by another checkout
./install.sh --help          # usage
```

Requires bash 4+ (macOS ships 3.2 — `brew install bash`).

Re-running is safe. Links already pointing into this repo are recreated in place; a real file is moved aside first, keeping the path it had under `~`, so `~/.config/nvim/init.lua` is backed up to `.backup/.config/nvim/init.lua.<timestamp>`.

If a target is a symlink into a *different* checkout, the run stops before writing anything and lists them. That guards against a development clone silently taking over the dotfiles in use — pass `--force` to repoint them deliberately.

## What's tracked

| Path | Symlinked to |
|---|---|
| `bash/.bashrc`, `.bash_profile`, `.bash_prompt`, `.bash_logout`, `.inputrc` | `~/` |
| `zsh/.zshrc`, `.zprofile`, `.zsh_prompt` | `~/` |
| `shell/.shell_aliases` | `~/` — sourced by both bash and zsh |
| `git/.gitconfig`, `.gitignore_global` | `~/` |
| `nvim/.config/nvim/init.lua` | `~/.config/nvim/init.lua` |
| `vim/.vimrc` | `~/` |
| `tmux/.tmux.conf` | `~/` |

## Per-machine overrides

The shell and git configs end by sourcing or including an optional `.local` counterpart in `$HOME`. Use these for anything that shouldn't be in version control or varies per machine: API keys, host-specific PATH entries, tool integrations only installed on some boxes (`nvm`, `pyenv`, `conda`, `rbenv`, `sdkman`), per-host git identity.

| Tracked file | Per-machine override | Mechanism |
|---|---|---|
| `~/.bashrc` | `~/.bashrc.local` | sourced if present |
| `~/.zshrc` | `~/.zshrc.local` | sourced if present |
| `~/.bash_profile` | `~/.bash_profile.local` | sourced if present — login shells only |
| `~/.zprofile` | `~/.zprofile.local` | sourced if present — login shells only |
| `~/.gitconfig` | `~/.gitconfig.local` | `[include]` — silently ignored if missing |

Create them by hand on each machine that needs them. Example `~/.gitconfig.local`:

```ini
[user]
    email = work@example.com
    signingkey = ABCD1234
[commit]
    gpgsign = true
```

### Gotcha: tools that write to your rc files

Because every tracked file is a symlink into this repo, two common cases will dirty the working tree:

1. **Shell tool installers** (nvm, pyenv, conda, rbenv, sdkman, uv) append a setup block to `~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`. The write follows the symlink into the tracked file.
2. **`git config --global ...`** writes to `~/.gitconfig`, also through the symlink.

When it happens:

```bash
git status                       # see what got dirtied
# move the added lines into the matching .local file:
#   bash/.bashrc        → ~/.bashrc.local
#   bash/.bash_profile  → ~/.bash_profile.local
#   zsh/.zshrc          → ~/.zshrc.local
#   zsh/.zprofile       → ~/.zprofile.local
#   git/.gitconfig      → ~/.gitconfig.local
git restore <file>               # discard the change in the tracked file
```

Always check `git status` after running a tool installer or pasting a `git config --global` line from a tutorial.

## Restoring

Remove the symlinks for the categories you installed — the paths are in the
table above — then copy back what you need from `.backup/`:

```bash
rm ~/.bashrc ~/.bash_profile ~/.bash_prompt ~/.bash_logout ~/.inputrc  # bash
rm ~/.config/nvim/init.lua                                             # nvim
```
