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

PROMPT=$'%{\e[0;91m%}%n %{\e[0;94m%}%~ %{\e[0;91m%}%# %{\e[m%}'

PATH="${PATH}:/home/taylor/bin"

source ~/.aliases
source ~/.functions

# Execute in bash
bdo() {
	echo "$@" | bash
}

## Options
setopt HIST_IGNORE_SPACE

