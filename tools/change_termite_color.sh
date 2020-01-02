#! /bin/bash

cdname="$(cd $(dirname $0); pwd)/.."
dname=base16-termite/themes/
theme=$(ls $dname | fzf)
cat termite_config_base $dname$theme | sed 's/\(background.*rgba(\)\(.*\))/\1\2, 0.8)/' > ${cdname}/.config/termite/config

