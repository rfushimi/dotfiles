#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
    
    # Key shortcuts (Merged)
    defaults write com.apple.FileMerge NSUserKeyEquivalents -dict-add "Quit FileMerge" "@w"
    defaults write com.google.Chrome.app.apkjikbjlghbonboeaehkeoadefnfjmb NSUserKeyEquivalents -dict-add "Reload This Page" "@8"
fi
