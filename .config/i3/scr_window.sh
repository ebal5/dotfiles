#!/bin/sh
tm=$(date -Iseconds)
fn=$(mktemp -p "${HOME}/Pictures/Screenshoots/" -t "scr_${tm}_XXXX.png")
xfce4-screenshooter -w -s $fn
