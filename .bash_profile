[ -f $HOME/.config/shell_profile.local ] && source $HOME/.config/shell_profile.local
[ -f $HOME/.config/shell_profile ] && source $HOME/.config/shell_profile

test -r ~/.bashrc && . ~/.bashrc
