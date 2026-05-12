# ~/.bashrc — interactive bash configuration

# Return early if not interactive
case $- in
    *i*) ;;
      *) return;;
esac

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth   # skip consecutive duplicates and lines starting with a space
shopt -s histappend      # append to history file on exit instead of overwriting
shopt -s cmdhist         # save multi-line commands as one history entry
shopt -s lithist         # preserve original newlines (avoids broken semicolon joining)
[ -f ~/.bash_history ] && chmod 600 ~/.bash_history

# ── Completion ────────────────────────────────────────────────────────────────
# Source the bash-completion package if installed (git, docker, npm, ssh, ...)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
        . /opt/homebrew/etc/profile.d/bash_completion.sh
    fi
fi

# ── Prompt ────────────────────────────────────────────────────────────────────
[ -f ~/.bash_prompt ] && . ~/.bash_prompt

# ── Aliases ───────────────────────────────────────────────────────────────────
[ -f ~/.shell_aliases ] && . ~/.shell_aliases

# ── Per-machine overrides (not tracked in dotfiles) ───────────────────────────
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
