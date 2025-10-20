#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
fi
