#!/bin/bash

# primary=$(polybar --list-monitors | grep '(primary)' | cut -d: -f1)

# for m in $(polybar --list-monitors | cut -d: -f1); do
#     if [[ $m = "$primary" ]] || [[ -z "$primary" ]]; then
#         tp=right
#     else
#         tp=none
#     fi
#     TRAY_POSITION=$tp MONITOR=$m polybar --reload main &
# done

TRAY_POSITION=none MONITOR=VIRTUAL2 polybar --reload main &
