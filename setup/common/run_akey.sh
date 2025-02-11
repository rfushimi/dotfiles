#!/bin/bash

if [[ ! -f $HOME/.ssh/akey ]]; then
    if ! command -v bw >/dev/null 2>&1; then
        echo "Installing akey: bitwarden-cli not found"
        exit 1
    fi
    if ! command -v jq >/dev/null 2>&1; then
        echo "Installing akey: jq not found"
        exit 1
    fi
    bw login fushimi.ryohei@gmail.com
    export BW_SESSION=$(bw unlock --raw)
    bw get item akey | jq -r '.notes' > $HOME/.ssh/akey
    chmod 600 $HOME/.ssh/akey
fi
