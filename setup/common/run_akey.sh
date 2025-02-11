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
    BW_SESSION=$(bw unlock --raw)
    KEY=$(bw get item akey | jq -r '.notes')
    if [ -n "$KEY" ]; then
        echo "$KEY" > "$HOME/.ssh/akey"
        echo "SSH key installed to $HOME/.ssh/akey"
    fi
    chmod 600 $HOME/.ssh/akey
fi
