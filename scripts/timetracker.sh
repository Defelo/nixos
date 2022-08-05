#!/bin/bash

if ! [[ $# =~ ^1|2$ ]] || ! [[ "$2" =~ ^(|start|stop|list|show|edit)$ ]]; then
    echo "Usage: $0 <name> [start|stop|list|show|edit]"
    exit 1
fi

FILE="$HOME/.timetracker/$1"
mkdir -p $(dirname "$FILE")
[[ -e "$FILE" ]] || touch "$FILE"

_fmt_ts() {
    date -d @$1 +"%a %d %b %Y %T"
}

_fmt_delta() {
    x=$1
    echo $((x/3600))h $((x/60%60))m $((x%60))s
}

_week() {
    date -d @$1 +"%G-%V"
}

_now() {
    date +"%s"
}

_running() {
    grep -E '^([0-9]+)$' "$FILE"
}

start() {
    if x=$(_running); then
        echo "Already running (started at $(_fmt_ts $x))"
        return 1
    fi
    now=$(_now | tee -a "$FILE")
    echo "Started at $(_fmt_ts $now)"
}

stop() {
    if ! x=$(_running); then
        echo "Not running"
        return 1
    fi
    now=$(_now)
    sed -i -E "s/^([0-9]+)$/\1 $now/" "$FILE"
    echo "Stopped at $(_fmt_ts $now) ($(_fmt_delta $((now-x))))"
}

list() {
    last=""
    w=0
    s=0
    r=""
    l=$(($(wc -l < "$FILE" | wc -c)-1))
    i=1
    while read begin end; do
        ln=$(printf "%0${l}d" $i)
        i=$((i+1))
        if [[ -z "$end" ]]; then
            end=$(_now)
            end_fmt="NOW"
            r="(running)"
        else
            end_fmt=$(_fmt_ts $end)
        fi
        week=$(_week $begin)
        if [[ "$last" != "$week" ]]; then
            [[ -n "$last" ]] && echo "=> $(_fmt_delta $w)"
            echo -e "\n$week"
            w=0
        fi
        last="$week"
        echo "#$ln $(_fmt_ts $begin) - $end_fmt ($(_fmt_delta $((end-begin))))"
        w=$((w+end-begin))
        s=$((s+end-begin))
    done < "$FILE"
    [[ -n "$last" ]] && echo "=> $(_fmt_delta $w)"
    echo -e "\nTOTAL: $(_fmt_delta $s) $r"
}

show() {
    sum=0
    r=""
    while read begin end; do
        if [[ -z "$end" ]]; then
            end=$(_now)
            r="(running)"
        fi
        sum=$((sum+end-begin))
    done < "$FILE"
    echo "$(_fmt_delta $sum) $r"
}

interactive() {
    _running>/dev/null || start
    f=1
    trap f=0 SIGINT
    while [[ $f = 1 ]]; do
        printf "\r%s" "$(show) (Ctrl+C to stop) "
        sleep 1
    done
    trap - SIGINT
    printf "\r"
    stop
}

edit() {
    ${EDITOR:-vi} "$FILE"
}

${2:-interactive}
