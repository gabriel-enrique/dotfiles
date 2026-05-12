# ~/.zshrc — interactive zsh configuration

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history       # required for SAVEHIST to persist anything
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_DUPS       # skip recording a command if identical to the previous one
setopt HIST_IGNORE_SPACE      # skip recording lines that start with a space
setopt INC_APPEND_HISTORY     # write each command to file immediately (crash-resilient)
[ -f ~/.zsh_history ] && chmod 600 ~/.zsh_history

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit

# case-insensitive + partial matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
                                    'r:|=*' \
                                    'l:|=* r:|=*'
zstyle ':completion:*' menu select                           # arrow-key menu navigation
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"      # colorize with LS_COLORS
zstyle ':completion:*' list-dirs-first true                  # group directories on top
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'  # nicer group headers

setopt AUTO_LIST            # list matches on ambiguous completion
setopt AUTO_MENU            # show completion menu on second Tab
setopt LIST_PACKED          # compact column layout
setopt NO_BEEP              # no audible bell

# ── Prompt ────────────────────────────────────────────────────────────────────
[ -f ~/.zsh_prompt ] && . ~/.zsh_prompt

# ── Aliases ───────────────────────────────────────────────────────────────────
[ -f ~/.shell_aliases ] && . ~/.shell_aliases

# ── Per-machine overrides (not tracked in dotfiles) ───────────────────────────
[ -f ~/.zshrc.local ] && . ~/.zshrc.local
