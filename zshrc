# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/taylor/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit

PROMPT=$'\e[0;91m%n \e[0;94m%1~ \e[0;91m%# \e[m'

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# My aliases
alias pacsize='pacman -Qi | egrep "Name|Installed Size" | sed -e '\''N;s/\n/ /'\'' | awk '\''{ print $7, $3}'\'' | sort -n' # list all installed packages and their sizes, sort by smallest first
#alias uterm='xrdb -merge ~/.Xresources'
alias uterm='xrdb ~/.Xresources'


# My aliases


bdo() {
	echo "$@" | bash
}

# Colored man pages
cman() {
    env	LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
