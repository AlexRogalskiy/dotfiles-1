# ENVIRONMENT
#############

export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
# GNU Colors
[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"

# ALIASES
#########

alias grep="grep --color=auto"
if [[ "$(uname)" =~ "Linux" ]]; then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi

# INTERNAL ZSH CONF
###################

# Modules

autoload -U colors; colors
autoload -U compinit; compinit
autoload -U promptinit; promptinit

zmodload zsh/complist
zmodload zsh/termcap

autoload -U zargs
autoload -U zmv
autoload -U zed
autoload -U zcalc
autoload -U zftp

# Options

unsetopt correct_all

# History

setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt BANG_HIST
HISTFILE=${HOME}/.zsh_history
SAVEHIST=50000
HISTSIZE=10000

# Keys
bindkey '^R' history-incremental-search-backward
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Ctrl+arrow keys to move one word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line

# Prompt

autoload -Uz vcs_info
autoload -U colors zsh/terminfo
setopt prompt_subst
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{${fg[cyan]}%}[%{${fg[green]}%}%s%{${fg[cyan]}%}][%{${fg[blue]}%}%r/%S%%{${fg[cyan]}%}][%{${fg[blue]}%}%b%{${fg[cyan]}%}][%{${fg[yellow]}%}%m%u%c%{${fg[cyan]}%}]%{$reset_color%}"

colors

precmd() {
    vcs_info
}

# Check the UID
if [[ $UID -eq 0 ]]; then
    PS1="%B%F%{$fg[red]%}%m%k %B%F%{$fg[blue]%}%1~ %# %b%f%k"
else
    PS1="%B%F%{$fg[green]%}%n@%m%k %B%F%{$fg[blue]%}%1~ %# %b%f%k"
fi

# set the prompt
PS2=$'%_>'
RPROMPT=$'${vcs_info_msg_0_}'

# SSH AGENT
###########

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# CUSTOM FUNCTIONS
##################

sprunge() {
    printf '%s%s\n' "$(curl -sF 'sprunge=<-' http://sprunge.us/)" "${*:+?$*}";
}

getdotfiles ()
{
    pushd > /dev/null
    git clone git@github.com:fim/dotfiles.git ${HOME}/dotfiles.git
    git --git-dir=${HOME}/dotfiles.git/.git/ --work-tree=${HOME} status | sed '/Untracked files:/q'
    echo "These files have changed. Press Enter to apply changes or Ctrl-C to cancel..." && read key
    cd ${HOME}
    for file in $(git --git-dir=${HOME}/dotfiles.git/.git/ --work-tree=${HOME} status -s --untracked=no | awk '{print $2}'); do
        cp ${HOME}/dotfiles.git/$file ${HOME}
    done
    rm -rf ${HOME}/dotfiles.git
    popd > /dev/null
}

# LOCAL OVERRIDES
#################

[ -f ~/.zshrc_local ] && . ~/.zshrc_local


# off we go
###########
command -v fortune &> /dev/null && fortune
