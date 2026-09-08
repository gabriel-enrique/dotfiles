# ~/.bash_profile — sourced by bash login shells (TTY, SSH, macOS Terminal)
# Non-login interactive shells (most terminal tabs on Linux) source .bashrc directly.
# Source .bashrc here so login shells get the full interactive setup too.

[ -f ~/.bashrc ] && . ~/.bashrc

# Login-only configuration goes below this line (rare; usually empty).

# Per-machine login-only overrides (not tracked in dotfiles). Installers that
# append a PATH export tend to pick this file, so give that a home outside the
# repository.
[ -f ~/.bash_profile.local ] && . ~/.bash_profile.local
