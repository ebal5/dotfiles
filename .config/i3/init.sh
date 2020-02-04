#!/bin/sh

$HOME/bin/xkeysnail.sh

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpgagent

target=$HOME/.config/i3/init.local.sh
[ -f $target ] && source $target
