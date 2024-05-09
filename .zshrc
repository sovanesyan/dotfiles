# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$DOTFILES

plugins=(git)

source $ZSH/oh-my-zsh.sh

eval "$(rbenv init - zsh)"

function opengh() {
    local repo_url=$(git config --get remote.origin.url)
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Convert SSH format to HTTPS format
    repo_url=${repo_url/git@github.com:/https://github.com/}
    repo_url=${repo_url/.git/}

    # Construct the URL to open the current branch's diff view
    local diff_url="${repo_url}/compare/${current_branch}"

    # Open the diff URL in the default web browser
    open "${diff_url}"
}

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/serge/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
