#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Symlinks 
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

rm -rf $HOME/.wezterm.lua
ln -s $HOME/.dotfiles/.wezterm.lua $HOME/.wezterm.lua

mkdir $HOME/.config/nvim

rm -rf $HOME/.config/nvim/init.lua
ln -s $HOME/.dotfiles/init.lua $HOME/.config/nvim/init.lua

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Configure git
git config --global user.name "Serge Ovanesyan"
git config --global user.email sovanesyan@gmail.com
git config --global rerere.enabled true
git config --global rerere.autoUpdate true
git config --global branch.sort -committerdate
git config --global column.ui auto
git maintenance start

# Volta
volta install node
volta install yarn

mkdir -p $HOME/w
mkdir -p $HOME/w/rb
mkdir -p $HOME/w/my


# Set macOS preferences - we will run this last because this will reload the shell
# source ./.macos
