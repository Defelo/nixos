#!/bin/bash

BEAMER_WIDTH=1024
BEAMER_HEIGHT=768

PRIMARY_WIDTH=1920
PRIMARY_HEIGHT=1080

create_mode() {
    modeline=$(cvt $@ | tail -1 | cut -d' ' -f2-)
    xrandr --newmode $modeline
    echo $modeline | cut -d' ' -f1
}

setup() {
    beamer=$(create_mode $BEAMER_WIDTH $BEAMER_HEIGHT 60)
    side=$(create_mode $((PRIMARY_WIDTH - BEAMER_WIDTH)) $PRIMARY_HEIGHT 60)
    bottom=$(create_mode $BEAMER_WIDTH $((PRIMARY_HEIGHT - BEAMER_HEIGHT)) 60)
    xrandr --addmode HDMI1 $beamer
    xrandr --addmode VIRTUAL1 $beamer
    xrandr --addmode VIRTUAL2 $side
    xrandr --addmode VIRTUAL3 $bottom

    xrandr --output HDMI1 --off
    xrandr --output VIRTUAL1 --mode $beamer --pos 0x0 --rotate normal
    xrandr --output VIRTUAL2 --mode $side --pos ${BEAMER_WIDTH}x0 --rotate normal
    xrandr --output VIRTUAL3 --mode $bottom --pos 0x${BEAMER_HEIGHT} --rotate normal
    xrandr --output VIRTUAL4 --off

    cd ~/.dotfiles/ && git switch beamer && ./dotter -vy && i3-msg restart

    xrandr --output eDP1 --off

    while read line; do
        ws=$(cut -d' ' -f2 <<< "$line")
        ws=$(grep "^set $ws " ~/.config/i3/config | cut -d' ' -f3-)
        out=$(cut -d' ' -f4 <<< "$line")
        i3-msg -t run_command "workspace $ws; move workspace to output $out;"
    done < <(grep ^workspace ~/.config/i3/config)

    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x1 --rotate normal
    xrandr --output HDMI1 --mode $beamer --pos 0x0 --rotate normal
}

teardown() {
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
    xrandr --output HDMI1 --off
    xrandr --output VIRTUAL1 --off
    xrandr --output VIRTUAL2 --off
    xrandr --output VIRTUAL3 --off

    cd ~/.dotfiles/ && git switch develop && ./dotter -vy && i3-msg restart
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
