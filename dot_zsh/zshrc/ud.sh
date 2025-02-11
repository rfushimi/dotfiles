function update-dotfiles() {
    echo "syncing main dotfiles..."
    cd ~/.local/share/chezmoi
    git add .
    git commit -m "dotfiles sync"
    git pull --rebase origin main
    git push -u origin main
    echo "done"

    echo "syncing corp dotfiles..."
    cd $HOME/corp-dotfiles
    git add .
    git commit -m "dotfiles sync"
    git pull origin main
    git push -u origin main
    echo "done"
}
