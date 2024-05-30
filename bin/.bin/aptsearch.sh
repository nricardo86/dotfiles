#!/bin/bash

#run as either doas or sudo
[ -x "$(command -v doas)" ] && [ -e /etc/doas.conf ] && ld="doas"
[ -x "$(command -v sudo)" ] && ld="sudo"

apt-cache search "" |
    sort |
    cut --delimiter " " --fields 1 |
    fzf --multi --exact --cycle --reverse --preview 'apt-cache search {1}' |
    xargs -r $ld apt install -yy
