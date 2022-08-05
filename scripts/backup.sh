#!/bin/bash

REPO=$(sudo cat /etc/borgmatic/repo)
BORG_PASSPHRASE=$(pass show Borg/$REPO) sudo --preserve-env=BORG_PASSPHRASE borgmatic -v1 --files --stats --progress
