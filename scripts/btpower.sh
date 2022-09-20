#!/bin/bash

mac=$(bluetoothctl devices Connected | cut -d' ' -f2 | tr : _)
[[ -n "$mac" ]] && path=$(upower -e | grep $mac)
[[ -n "$path" ]] && res=$(upower -i "$path" | grep percentage | awk '{print $2}')
res=${res:-0%}
polybar-msg action btpower module_$([[ "$res" != "0%" ]] && echo show || echo hide) > /dev/null
echo " $res"
