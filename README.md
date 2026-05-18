# Dotfiles

Personal configs for shell (Bash, Zsh), Git, editors (Neovim, Vim), and tmux. Installed via `install.sh`, which symlinks tracked files into `$HOME`.

## Install

```bash
./install.sh                 # everything
./install.sh bash git        # selected categories
./install.sh --list          # show categories
```

Re-running is safe: existing symlinks are skipped, real files get backed up under `.backup/<name>.<timestamp>` before being replaced.

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

Tracked configs end by sourcing or including an optional `.local` counterpart in `$HOME`. Use these for anything that shouldn't be in version control or varies per machine: API keys, host-specific PATH entries, tool integrations only installed on some boxes (`nvm`, `pyenv`, `conda`, `rbenv`, `sdkman`), per-host git identity.

| Tracked file | Per-machine override | Mechanism |
|---|---|---|
| `~/.bashrc` | `~/.bashrc.local` | sourced if present |
| `~/.zshrc` | `~/.zshrc.local` | sourced if present |
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

Because `~/.bashrc`, `~/.zshrc`, and `~/.gitconfig` are symlinks into this repo, two common cases will dirty the working tree:

1. **Shell tool installers** (nvm, pyenv, conda, rbenv, sdkman) append a setup block to `~/.bashrc` / `~/.zshrc`. The write follows the symlink into the tracked file.
2. **`git config --global ...`** writes to `~/.gitconfig`, also through the symlink.

When it happens:

```bash
git status                       # see what got dirtied
# move the added lines into the matching .local file:
#   bash/.bashrc      → ~/.bashrc.local
#   zsh/.zshrc        → ~/.zshrc.local
#   git/.gitconfig    → ~/.gitconfig.local
git restore <file>               # discard the change in the tracked file
```

Always check `git status` after running a tool installer or pasting a `git config --global` line from a tutorial.

## Restoring

To unlink everything and recover originals:

```bash
rm ~/.bashrc ~/.bash_profile ~/.bash_prompt ~/.bash_logout ~/.inputrc \
   ~/.zshrc ~/.zprofile ~/.zsh_prompt \
   ~/.shell_aliases ~/.gitconfig ~/.gitignore_global \
   ~/.vimrc ~/.tmux.conf
# then copy back from .backup/ as needed
```
