#!/usr/bin/env bash

set -ex

name=$(date +"%F_%T")

curl ${HEALTHCHECK}/start

exclude=""
if [[ "$EXCLUDE_SYNCTHING" = "1" ]]; then
    for path in $(xq -r '.configuration.folder[]|select(.paused=="false")|."@path"' ~/.config/syncthing/config.xml); do
        exclude="$exclude --exclude $path"
    done
fi

echo "Creating backup $name"
sudo --preserve-env="SSH_AUTH_SOCK,BORG_REPO,BORG_PASSCOMMAND" \
    borg create --stats --progress --compression lz4 \
    --exclude '**/*cache*' \
    --exclude '**/*Cache*' \
    --exclude '/home/*/.npm' \
    --exclude '/home/*/.wine' \
    --exclude '/home/*/.konan' \
    --exclude '/home/*/.thunderbird' \
    --exclude '/home/*/.rustup' \
    --exclude '/home/*/.nuget' \
    --exclude '/home/*/.cargo' \
    --exclude '/home/*/Downloads' \
    --exclude '/home/*/.local/share/JetBrains/Toolbox/apps' \
    --exclude '/home/*/.local/share/JetBrains/Toolbox/download' \
    --exclude '/home/*/.local/pipx/venvs' \
    --exclude '**/node_modules' \
    --exclude '**/target' \
    --exclude '**/target-tarpaulin' \
    --exclude '**/.venv' \
    $exclude \
    ::$name \
    /home \
    || true  # https://github.com/borgbackup/borg/issues/6379

borg prune -v --list --keep-daily=4 --keep-weekly=3 --keep-monthly=2
borg compact

curl ${HEALTHCHECK}
