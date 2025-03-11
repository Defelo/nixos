#!/usr/bin/env bash

export GIT_DIR=$HOME/.timetracker/.git
export GIT_WORK_TREE=$HOME/.timetracker

_usage() {
  echo "Usage: tt <name> [start|stop|list|show|edit|config|delete|save] [<args>]"
  echo "       tt list"
  echo "       tt git [<args>]"
  exit 1
}

if [[ $1 == git ]]; then
  shift
  exec git "$@"
elif [[ $1 == list ]]; then
  [[ $# == 1 ]] || _usage
  for file in $(
    cd $GIT_WORK_TREE
    ls
  ); do
    echo $file
  done
  exit
elif [[ $# -lt 1 ]] || ! [[ $2 =~ ^(|start|stop|list|show|edit|config|delete|save)$ ]]; then
  _usage
fi

if ! git status &>/dev/null; then
  git init
fi

NAME="$1"
FILE="$HOME/.timetracker/$1"
CONF="$HOME/.timetracker/.$1.yml"
if [[ $2 != delete ]]; then
  mkdir -p $(dirname "$FILE")
  [[ -e $FILE ]] || touch "$FILE"
  [[ -e $CONF ]] || cat <<EOF >"$CONF"
regular: 0  # per week
start: 0
bonus: []  # hours
salary: 0  # €/month
EOF

  PER_WEEK=$(yq -r .regular "$CONF")
  START=$(yq -r .start "$CONF")
  BONUS=$(yq -r '.bonus+[0]|add*60*60|round' "$CONF")
  SALARY=$(yq -r .salary "$CONF")
fi

_fmt_ts() {
  date -d @$1 +"%a %d %b %Y %T"
}

_fmt_delta() {
  x=$1
  echo $((x / 3600))h $((x / 60 % 60))m $((x % 60))s
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

_overtime() {
  [[ $PER_WEEK -gt 0 ]] || return

  t=$(($(_now) - START))
  regular=$(jq -n "$PER_WEEK*$t/(24*7)|round-($BONUS)")
  until=$(jq -n "$START+($1+($BONUS))/$PER_WEEK*24*7|round")
  money=$(jq -n "$SALARY*($1-$regular)/3600/$PER_WEEK/52*12*100|round/100")
  echo "Overtime: $(_fmt_delta $(($1 - regular))) (until $(_fmt_ts $until); ${money}€)"
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
  echo "Stopped at $(_fmt_ts $now) ($(_fmt_delta $((now - x))))"
  save
}

list() {
  cnt=${1:-all}
  last=""
  w=0
  s=0
  r=""
  lines=$(wc -l <"$FILE")
  l=${#lines}
  i=1
  while read begin end; do
    [[ $cnt == all ]] || [[ $i -gt $((lines - cnt)) ]]
    out=$?
    ln=$(printf "%0${l}d" $i)
    i=$((i + 1))
    if [[ -z $end ]]; then
      end=$(_now)
      end_fmt="NOW"
      r="(running)"
    else
      end_fmt=$(_fmt_ts $end)
    fi
    week=$(_week $begin)
    if [[ $last != "$week" ]]; then
      [[ $out == 0 ]] && [[ -n $last ]] && echo "=> $(_fmt_delta $w)"
      [[ $out == 0 ]] && echo -e "\n$week"
      w=0
    fi
    last="$week"
    [[ $out == 0 ]] && echo "#$ln $(_fmt_ts $begin) - $end_fmt ($(_fmt_delta $((end - begin))))"
    w=$((w + end - begin))
    s=$((s + end - begin))
  done <"$FILE"
  [[ -n $last ]] && echo "=> $(_fmt_delta $w)"
  echo -e "\nTOTAL: $(_fmt_delta $s) $r"
  _overtime $s
}

show() {
  sum=0
  r=""
  while read begin end; do
    if [[ -z $end ]]; then
      end=$(_now)
      r="(running)"
    fi
    sum=$((sum + end - begin))
  done <"$FILE"
  echo "TOTAL: $(_fmt_delta $sum) $r"
  _overtime $sum
}

interactive() {
  _running >/dev/null || start
  x=$(_running)
  f=1
  trap f=0 SIGINT
  first=1
  while [[ $f == 1 ]]; do
    s=$(show)
    printf "${new}Current: $(_fmt_delta $(($(_now) - x)))\n$s (Ctrl+C to stop) "
    sleep 1
    if [[ $first == 1 ]]; then
      new=$(tput cuu $(echo -e "$s" | wc -l) hpa 0 ed)
      first=0
    fi
  done
  trap - SIGINT
  printf "$new"
  stop
}

edit() {
  ${EDITOR:-vi} "$FILE"
  save
}

config() {
  ${EDITOR:-vi} "$CONF"
  save
}

delete() {
  for file in "$FILE" "$CONF"; do
    [[ -e $file ]] && rm -i "$file" || echo "$file does not exist"
  done
  save
}

save() {
  git add "$FILE" "$CONF"
  if ! git diff --staged --exit-code --quiet; then
    git commit -m "Update $NAME"
    git push
  fi
}

cmd=${2:-interactive}
shift 2
"$cmd" "$@"
