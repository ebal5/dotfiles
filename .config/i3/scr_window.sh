#!/bin/sh
fn=$(mktemp -p "${HOME}/Pictures/Screenshoots/" -t 'scr.XXXXXX.png')
xfce4-screenshooter -w -s $fn
