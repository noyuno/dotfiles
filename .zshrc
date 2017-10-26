# ------------------------------
# General Settings
# ------------------------------

if [ "$TERM" = linux ]; then
    export LANG=C
else
    [ "$TMUX" ] && export TERM=screen-256color
    export LANG=ja_JP.UTF-8
fi 

export EDITOR=vim
export KCODE=u
export AUTOFEATURE=true
export XDG_CONFIG_HOME=$HOME/.config

bindkey -e
#bindkey -v

setopt nonomatch
setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt correct
setopt magic_equal_subst
setopt prompt_subst
setopt notify
setopt equals
setopt interactivecomments
#setopt no_rm_star_silent # silent rm *

### Complement ###
fpath=(~/dotfiles/zsh-completions $fpath)
autoload -U compinit; compinit -u
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types
bindkey "^[[Z" reverse-menu-complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

### Glob ###
setopt extended_glob
unsetopt caseglob

### History ###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt bang_hist
setopt extended_history
setopt hist_ignore_dups
setopt share_history
setopt hist_reduce_blanks
setopt rm_star_silent

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

function history-all { history -E 1 }


# ------------------------------
# Look And Feel Settings
# ------------------------------
### Ls Color ###
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORS
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=1

### Prompt ###
export DISABLE_AUTO_TITLE="false"
autoload -U colors; colors
autoload -Uz vcs_info; setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{green}s"
zstyle ':vcs_info:git:*' unstagedstr "%F{green}u"
zstyle ':vcs_info:*' formats "%F{green}%c%u"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

preexec(){
    [ "$TMUX" ] && bash $HOME/dotfiles/tmux/window-status.sh normal exec
}
precmd(){
    ret="$?"
    [ "$ret" -eq 0 ] && ret=
    vcs_info
    if [ "$TMUX" ]; then
        bash $HOME/dotfiles/tmux/window-status.sh normal prompt
        tmux refresh-client -S
    fi
}
PROMPT="[%F{green}${USER}@${HOST%%.*} %F{blue}%~%f] %(!.#.$) "
PROMPT2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
RPROMPT='${ret}${vcs_info_msg_0_}'
RPROMPT_ORIG="$RPROMPT"
SPROMPT="%{${fg[yellow]}%}Did you mean '%r'? [yNea]:%{${reset_color}%}"
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="[%F{green}${USER}%F{yellow}@${HOST%%.*}%F{blue} %~%f] %(!.#.$) "
;

# ------------------------------
# Other Settings
# ------------------------------
### RVM ###
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

[ -f "$HOME/.zsh_aliases" ] && . $HOME/.zsh_aliases

function cd() {
    builtin cd $@
    if [ $? -eq 0 ]; then
        dirc
        if [ $(ls -U1 | wc -l) -lt 50 ]; then
            case ${OSTYPE} in
                linux*) ls --color ;;
                darwin*) ls -G ;;
                *) ls ;;
            esac && \
            [ "$TMUX" ] && tmux refresh-client -S
        fi
    fi
}

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
which dircolors 1>/dev/null 2>&1
[ $? -eq 0 ] && eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zsh_version_is_5="0"
if [[ "`zsh --version`" =~ ^zsh\ 5.*$ ]]; then
    zsh_version_is_5="1"
    # antigen
    if [ ! -e ~/.cache/antigen ]; then
        mkdir -p ~/.cache
        git clone https://github.com/zsh-users/antigen.git ~/.cache/antigen --depth 1
    fi
    source ~/.cache/antigen/antigen.zsh

    if which antigen 1>/dev/null 2>&1; then
        antigen bundle zsh-users/zsh-syntax-highlighting
        antigen bundle zsh-users/zsh-completions
        antigen bundle zsh-users/zsh-autosuggestions
        antigen bundle mollifier/cd-gitroot
        antigen apply
    fi
fi


# colorscheme
if [ "$TERM" != linux ]; then
    #eval `dircolors ~/dotfiles/dircolors.256dark`
#    terminalcolors.py color_mapping ~/dotfiles/vim/colors/hybrid.vim
fi 

if [ ~/dotfiles/.zshrc -nt ~/.zshrc.zwc ]; then
    zcompile ~/.zshrc 
fi 

[ "$zsh_version_is_5" = "1" ] && [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# gpg
GPG_TTY=$(tty)
export GPG_TTY

# C-s
stty stop undef

# shellcheck
export SHELLCHECK_OPTS="-e SC2002 -e SC2016"

# wiki
export WIKI_LANG="ja"

# SSH
if [ ! -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    if [ -x /usr/bin/keychain -a ! -e "$HOME/.keychain/$(hostname)-sh" ]; then
        /usr/bin/keychain --quiet --clear $HOME/.ssh/id_rsa
    fi
fi

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

#ruby
which rbenv 1>/dev/null 2>&1 &&:
if [ $? -eq 0 ]; then
    eval "$(rbenv init -)"
fi

# direnv
which direnv 1>/dev/null 2>&1 &&:
if [ $? -eq 0 ]; then
    eval "$(direnv hook zsh)"
fi

