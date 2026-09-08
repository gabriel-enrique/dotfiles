# ~/.zprofile — sourced by zsh login shells (TTY, SSH)
# Unlike bash, zsh runs .zshrc for any interactive shell (login or not),
# so this file is reserved for things that should run exactly once per login
# (e.g. one-shot environment exports, ssh-agent bootstrap).
#
# Nothing tracked belongs here; the one line below just gives installers that
# write to a login profile somewhere to be moved to.

# Per-machine login-only overrides (not tracked in dotfiles)
[ -f ~/.zprofile.local ] && . ~/.zprofile.local
