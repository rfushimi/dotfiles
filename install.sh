#!/usr/bin/env zsh

if read -q "choice?Install dotfiles? [y/n]:\n"; then
    # Relative path from home directory.
    DOTFILES=dotfiles
    DOTFILES_PATH=~/$DOTFILES_PATH

    cd ~
    if [[ ! -d $DOTFILES ]] then
        git clone https://github.com/rfushimi/dotfiles.git $DOTFILES
    fi

    # My corp $USER is "fushimi" ("ryohei" for private machines)
    if [[ $USER = "fushimi" ]] then
        if [ ! -d $DOTFILES/corp-dotfiles ]; then
            echo "Setting up corp machine."
            gcert
            git submodule add sso://user/$USER/corp-dotfiles $DOTFILES/corp-dotfiles
            git submodule update --init --recursive
        fi
    fi

    # Link
    ln -sf $DOTFILES/zshrc .zshrc
    ln -sf $DOTFILES/gitconfig .gitconfig
    ln -sf $DOTFILES/gitignore .gitignore

    # SSH - be careful.
    mkdir -p ~/.ssh
    if [[ ! -L .ssh/config ]] then
        cp ~/.ssh/config ~/.ssh/config.orig
    fi
    echo "Successfully installed dotfiles."
fi

ln -sf $DOTFILE/ssh-config ~/.ssh/config
source ~/.zshrc > /dev/null

case "${OSTYPE}" in
darwin*)
    zsh $DOTFILES/corp-dotfiles/install.sh

    if read -q "choice?Install HomeBrew? [y/n]:\n"; then
        echo $choice2
        # Install homebrew - use at your own risk.
        if [[ $HOMEBREW_DIR =~ "^$HOME" ]] then
            echo "Setting up homebrew for custom directory: $HOMEBREW_DIR"
            mkdir $HOMEBREW_DIR && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOMEBREW_DIR
        else
            echo "Setting up homebrew for standard directory: $HOMEBREW_DIR"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi

    if read -q "choice?Run `brew bundle`? [y/n]:"; then
        echo "Running `brew bundle`..."
        brew bundle
        if [[ $USER = "fushimi" ]] then
        else
            # non-corp dev
            brew install visual-studio-code
            brew install docker docker-compose
            # media
            brew install obs xquartz
            # apps
            brew install steam epic-games bitwarden kindle notion slack spotify
        fi

        # Optional apps
        brew install adobe-creative-cloud
        brew install coteditor
        brew install google-cloud-sdk
        brew install google-japanese-ime
    fi
    
    ;;
esac
