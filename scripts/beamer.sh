#!/usr/bin/env bash

BEAMER_WIDTH=1024
BEAMER_HEIGHT=768

PRIMARY_WIDTH=1920
PRIMARY_HEIGHT=1080

create_mode() {
    modeline=$(cvt $@ | tail -1 | cut -d' ' -f2-)
    xrandr --newmode $modeline
    echo $modeline | cut -d' ' -f1
}

add_mode() {
    while ! (xrandr | grep -q "$1"); do
        sleep .1
    done
    xrandr --addmode "$1" "$2"
}

cp_conf() {
    path=$(realpath "$1")
    cp -P "$1" "${1}.bak"
    rm "$1"
    cp "$path" "$1"
    chmod +w "$1"
}

rs_conf() {
    mv -f "${1}.bak" "$1"
}

setup() {
    beamer=$(create_mode $BEAMER_WIDTH $BEAMER_HEIGHT 60)
    side=$(create_mode $((PRIMARY_WIDTH - BEAMER_WIDTH)) $PRIMARY_HEIGHT 60)
    bottom=$(create_mode $BEAMER_WIDTH $((PRIMARY_HEIGHT - BEAMER_HEIGHT)) 60)
    add_mode HDMI1 $beamer
    add_mode VIRTUAL1 $beamer
    add_mode VIRTUAL2 $side
    add_mode VIRTUAL3 $bottom

    xrandr --output HDMI1 --off
    xrandr --output VIRTUAL1 --mode $beamer --pos 0x0 --rotate normal
    xrandr --output VIRTUAL2 --mode $side --pos ${BEAMER_WIDTH}x0 --rotate normal
    xrandr --output VIRTUAL3 --mode $bottom --pos 0x${BEAMER_HEIGHT} --rotate normal
    xrandr --output VIRTUAL4 --off

    cp_conf ~/.config/i3/config
    for tpl in "1:0 " "2:1 " "2:2 " "2:3 " "2:4 " "2:5 " "2:6 " "2:7 " "2:8 " "2:9 " "2:10 " "2:42 " "2:1337" "3:+ "; do
        ws=$(cut -d':' -f2 <<< "$tpl")
        out=$(cut -d':' -f1 <<< "$tpl")
        echo "workspace \"$ws\" output VIRTUAL$out" >> ~/.config/i3/config
    done

    cp_conf ~/.config/dunst/dunstrc
    sed -i 's/^follow="mouse"/# \0/' ~/.config/dunst/dunstrc

    cp_conf ~/.config/polybar/config.ini
    sed -i -E 's/^tray-position=.+/tray-position=none\nmonitor=VIRTUAL2/' ~/.config/polybar/config.ini
    sed -i -E 's/^(pin-workspaces)=.+/\1=false/' ~/.config/polybar/config.ini
    sed -i -E 's/^(modules-left)=.*/\1=workspaces scratch/' ~/.config/polybar/config.ini
    sed -i -E 's/^(modules-right)=.*/\1=mem swap dunst battery network-wired network-wireless date/' ~/.config/polybar/config.ini
    sed -i -E 's/^(label-connected)=([^ ]+) .*/\1=\2 %netspeed%/' ~/.config/polybar/config.ini

    i3-msg restart
    systemctl --user restart dunst
    systemctl --user restart polybar

    while read line; do
        ws=$(cut -d'"' -f2 <<< "$line")
        out=$(cut -d'"' -f3 <<< "$line" | cut -d ' ' -f3)
        echo "i3-msg -t" run_command "workspace $ws; move workspace to output $out;"
        i3-msg -t run_command "workspace $ws; move workspace to output $out;"
    done < <(grep "^workspace " ~/.config/i3/config)

    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x1 --rotate normal
    xrandr --output HDMI1 --mode $beamer --pos 0x0 --rotate normal

    feh --bg-fill ~/nixos/wallpapers/nix-simple-geometric.png

    dunstctl set-paused true
}

teardown() {
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
    xrandr --output HDMI1 --off
    xrandr --output VIRTUAL1 --off
    xrandr --output VIRTUAL2 --off
    xrandr --output VIRTUAL3 --off

    rs_conf ~/.config/i3/config
    rs_conf ~/.config/dunst/dunstrc
    rs_conf ~/.config/polybar/config.ini

    i3-msg restart
    systemctl --user restart dunst
    systemctl --user restart polybar

    feh --bg-fill ~/nixos/wallpapers/default.png
}

check() {
    xrandr --listmonitors | grep -Eq 'HDMI|VIRTUAL'
}

toggle() {
    if check; then
        teardown
    else
        setup
    fi
}

if [[ "$1" =~ ^(setup|teardown|toggle|check)$ ]]; then
    $1
else
    echo "usage: $0 setup|teardown|toggle|check"
fi
