#!/usr/bin/env bash
if pgrep xkeysnail > /dev/null; then
    return 2>&-
fi
if ! which xkeysnail > /dev/null; then
    return 2>&-
fi
if ! pgrep xkeysnail > /dev/null && [ -f $HOME/.config/xkeysnail/config.py ]; then
    exec >> /tmp/xkeysnail.log 2>&1
    xhost +SI:localuser:xkeysnail > /dev/null
    tmp=$(mktemp /tmp/xkeysnail.XXXX.py)
    cp $HOME/.config/xkeysnail/config.py $tmp
    chmod o+r $tmp
    sudo -u xkeysnail DISPLAY=$DISPLAY /usr/bin/xkeysnail $tmp > /dev/null &
    eval "sleep 5 && rm -f $tmp" &
fi
