#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# User settings
[ -f $HOME/.config/shell_profile.local ] && source $HOME/.config/shell_profile.local
[ -f $HOME/.config/shell_profile ] && source $HOME/.config/shell_profile
