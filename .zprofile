# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

function addpath()
{
    if [ -d "$1" ]; then
        PATH="$1:$PATH"
    fi
}

# set PATH so it includes user's private bin if it exists
addpath "$HOME/bin"
addpath "$HOME/.local/bin"
addpath "$HOME/dotfiles/bin"
addpath "/usr/local/texlive/2015/bin/x86_64-linux"
addpath "$HOME/.gem/ruby/2.3.0/bin"
addpath "$HOME/.password-store/bin"
addpath "$HOME/.cargo/bin"
addpath "$HOME/.rbenv/bin"
if [ -d "$HOME/.go" ]; then
    export GOPATH="$HOME/.go"
    addpath "$GOPATH/bin"
fi

export MAILDIR="$HOME/Mail"
if [ -d "$HOME/.npm" ]; then
    export NPM_PACKAGES="$HOME/.npm"
    addpath "$NPM_PACKAGES/bin"
fi

#git
if [[ "`git --version`" =~ ^git\ version\ 2.*$ ]]; then
    ln -sf "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"
else
    cat "$HOME/dotfiles/.gitconfig" | \
        grep -v 'default\s=\ssimple' > \
        "$HOME/.gitconfig.legacy"
    ln -sf "$HOME/.gitconfig.legacy" "$HOME/.gitconfig"
fi

# fcitx on X11 Forwarding
#which fcitx 1>/dev/null 2>&1
#if [ $? -eq 0 -a "${DISPLAY//:.*/}" -a ! "$(pgrep fcitx)" ]; then
#    fcitx
#fi

# Neovim
export NVIM_TUI_ENABLE_CURSOR_SHAPE=0

(
if [ -e "$HOME/.keychain/$(hostname)-sh" ]; then
    rm $HOME/.keychain/$(hostname)-sh
fi
) 1>/dev/null 2>&1

