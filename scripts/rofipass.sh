#!/usr/bin/env bash

shopt -s globstar

cd $PASSWORD_STORE_DIR
if x=$((for f in $(find * -type f -name '*.gpg'); do echo "${f%.gpg}"; done) | rofi -dmenu -no-custom); then
    if PASSWORD_STORE_CLIP_TIME=10 pass show --clip "$x"; then
        dunstify -t 10000 "Password Store" "copied '$x' to clipboard"
    fi
fi
