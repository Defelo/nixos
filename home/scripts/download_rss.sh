#!/usr/bin/env bash

set -e

download_from_rss() {
    d=$(curl -s "$1" | xq -r ".rss.channel.item[${3:-0}]")
    jq -r .title <<< "$d"
    url=$(jq -r '.enclosure."@url"' <<< "$d")
    echo "$url"
    pub=$(jq -r '.pubDate' <<< "$d")
    name=$(date -d "$pub" +"$2_%Y_%m_%d.mp4")
    wget --continue -O "$name" "$url"
}

future=$3
declare -A urls=(
    ["x3"]="http://www.ndr.de/fernsehen/sendungen/extra_3/video-podcast/extradrei196_version-hq.xml"
    ["hs"]="https://mediathekviewweb.de/feed?query=heute-show%20!ZDF&future=$future"
    ["zmr"]="https://mediathekviewweb.de/feed?query=zdf%20magazin%20royale%20!ZDF&future=$future"
    ["m"]="https://mediathekviewweb.de/feed?query=!zdf%20wir%20sind%20die%20meiers&future=$future"
    ["zcs"]="https://mediathekviewweb.de/feed?query=!zdf%20zdf%20comedy%20sommer&future=$future"
)

download_from_rss "${urls[$1]}" "$1" ${2:-0}
