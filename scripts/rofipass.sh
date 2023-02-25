#!/usr/bin/env bash

shopt -s globstar

cd $PASSWORD_STORE_DIR
if x=$((for f in $(find * -type f -name '*.gpg'); do echo "${f%.gpg}"; done) | rofi -dmenu -no-custom -matching fuzzy); then
    password=$(pass show "$x")
    xdotool type --clearmodifiers -f - <<< "$password"
fi
