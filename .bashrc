
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# ENVIRONMENT
#############
export PS1="\[\033[01;33m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# ALIASES
#########

alias grep="grep --color=auto"

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
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

# FUNCTIONS
###########

function sprunge ()
{
    curl -sF 'sprunge=<-' 'http://sprunge.us' <"${1:-/dev/stdin}"
}

function getdotfiles ()
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

# Fortune cookie
################
command -v fortune &> /dev/null && fortune
