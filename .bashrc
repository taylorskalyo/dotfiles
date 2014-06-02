# -----------------
# Variables
# ------------------------------------------------------------------------------
export PATH="$PATH:$HOME/.rvm/bin"			# rvm bin
export PATH="$PATH:/usr/local/mysql/bin"	# mysql bin
export GOPATH="$HOME/code/go"				# go path
export PATH="$PATH:$GOPATH/bin"				# go bin
export PATH="$PATH:$HOME/bin"				# home bin

# -----------------
# History
# ------------------------------------------------------------------------------
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth

# -----------------
# Tab Completion
# ------------------------------------------------------------------------------
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# -----------------
# Options
# ------------------------------------------------------------------------------
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

# -----------------
# Prompt
# ------------------------------------------------------------------------------
PS1='\[\e[0;92m\]\u \[\e[0;94m\]\w \[\e[0;92m\]\$ \[\e[m\]'

# -----------------
# External Resources
# ------------------------------------------------------------------------------
RESOURCES=(~/.aliases ~/.functions ~/.cgrc)
for FILE in $RESOURCES; do
	if [ -f $FILE ]; then
		source $FILE
	fi
done


