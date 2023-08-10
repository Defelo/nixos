#!/usr/bin/env bash

shopt -s globstar

cd $PASSWORD_STORE_DIR
if x=$((for f in $(find * -type f -name '*.gpg'); do echo "${f%.gpg}"; done) | rofi -dmenu -no-custom -matching fuzzy); then
    password=$(pass show "$x" | head -1)

    # prevent clipman from storing the password
    [[ -f ~/.local/share/clipman.json ]] || echo -n '[]' > ~/.local/share/clipman.json
    chmod u-w ~/.local/share/clipman.json
    wl-copy -n <<< "$password"
    (sleep 1; chmod u+w ~/.local/share/clipman.json)

    dunstify -t 5000 'Password copied to clipboard'
    sleep 5
    wl-copy -c
    clipman pick -t CUSTOM -T "head -1"  # restore last clipboard entry
fi
