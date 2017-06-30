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

if which brew &>/dev/null; then
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
	  . $(brew --prefix)/etc/bash_completion
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1="\$(date \"+%H:%M:%S\") \u@\h \w\$(parse_git_branch) $\n"

[ -n "${TMUX+x}" ] || $HOME/bin/grabssh

PROMPT_COMMAND="[ -f $HOME/bin/fixssh ] && source $HOME/bin/fixssh"

export PATH="$HOME/.rbenv/bin:/opt/packer/bin:$PATH"
export RBENV_ROOT=~/.rbenv
export PATH=${PATH}:$HOME/gsutil
export PATH="${PATH}:/usr/local/go/bin"

# ec2-status --profile crohr --region us-east-1
ec2-status() {
	aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,LaunchTime,State.Name]' --output text "$@" | sort -n -k 2
}

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
PATH="/usr/local/heroku/bin:$PATH"
alias http="python -m SimpleHTTPServer"
