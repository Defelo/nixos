#!/usr/bin/env bash

shopt -s globstar

export PASSWORD_STORE_CLIP_TIME=2

cd $PASSWORD_STORE_DIR
if x=$((for f in $(find * -type f -name '*.gpg'); do echo "${f%.gpg}"; done) | rofi -dmenu -no-custom -matching fuzzy); then
    if pass show --clip "$x"; then
        dunstify -t $((PASSWORD_STORE_CLIP_TIME * 1000)) "Password Store" "copied '$x' to clipboard"
    fi
fi
