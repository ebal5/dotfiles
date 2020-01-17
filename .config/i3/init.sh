#!/bin/sh

$HOME/bin/xkeysnail.sh

target=$HOME/.config/i3/init.local.sh
[ -f $target ] && source $target
