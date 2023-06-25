#!/usr/bin/env bash

while read line; do
	message=$(jq -r .message <<< "$line")
	if ! title=$(jq -e -r .title <<< "$line"); then
		title="$message"
		message=""
	fi
	prio=$(jq -e -r .priority <<< "$line") || prio=3
	if [[ $prio -lt 3 ]]; then
		prio=0
	elif [[ $prio -eq 3 ]]; then
		prio=1
	else
		prio=2
	fi

	actions=()
	while read act; do
		id=$(jq -r .id <<< "$act")
		action=$(jq -r .action <<< "$act")
		[[ "$action" = "view" ]] || continue
		label=$(jq -r .label <<< "$act")
		actions+=("-A" "$id,$label")
	done < <(jq -c '.actions[]' <<< "$line")

	id=$(dunstify "${actions[@]}" -u $prio "$title" "$message")
	if url=$(jq -e --arg id "$id" -r '.actions[]|select(.id==$id)|.url' <<< "$line"); then
		xdg-open "$url"
	fi
done < <(ntfy sub -C -c "$1")
