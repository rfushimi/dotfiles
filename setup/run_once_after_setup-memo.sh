#!/bin/bash

# Clone the memo repository if it doesn't already exist
if [ ! -d "$HOME/memo" ]; then
    echo "Cloning memo repository..."
    git clone sso://user/fushimi/corp-notes "$HOME/memo"
else
    echo "~/memo already exists, skipping clone."
fi
