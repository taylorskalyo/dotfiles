if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth

PATH="${PATH}:/home/taylor/bin"

# prompt
#PS1='[\u@\h \W]\$ '
#PS1='\[\e[0;92m\]\u\[\e[m\] \[\e[0;94m\]\w\[\e[m\] \[\e[0;92m\]\$\[\e[m\] '
PS1='\[\e[0;91m\]\u \[\e[0;94m\]\w \[\e[0;91m\]\$ \[\e[m\]'

source ~/.aliases

alias man='cman'		# Use colored manpages; cman is in ~/.functions

source ~/.functions

# Execute in zsh
zdo() {
	echo "$@" | zsh
}
