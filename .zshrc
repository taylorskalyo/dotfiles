# -----------------
# Variables
# ------------------------------------------------------------------------------
export PATH="$PATH:$HOME/.rvm/bin"        # rvm bin
export PATH="$PATH:/usr/local/mysql/bin"  # mysql bin
#export GOROOT="$HOME/code/go"             # go root
export GOPATH="$HOME/code/go"             # go path
export GOBIN="$HOME/code/go/bin"          # go bin
export PATH="$PATH:$GOBIN"                # go bin
export PATH="$PATH:$HOME/bin"             # home bin
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin" # psql bin
export CGROOT="$HOME/code/codeguard"

# -----------------
# Vim-Like Bindings
# ------------------------------------------------------------------------------
bindkey -v

# Reduce mode switch lag
export KEYTIMEOUT=3

# -----------------
# History
# ------------------------------------------------------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_SPACE

# Search history
bindkey "^R" history-incremental-search-backward

# -----------------
# Tab Completion
# ------------------------------------------------------------------------------
#zstyle :compinstall filename '/home/taylor/.zshrc'
autoload -Uz compinit
compinit

# Teamocil completion
compctl -g '~/.teamocil/*(:t:r)' teamocil

# -----------------
# Colors
# ------------------------------------------------------------------------------
autoload -U colors
colors

# -----------------
# Right Prompt
# ------------------------------------------------------------------------------
VIM_NORMAL="%{$fg_bold[yellow]%}CMD-MODE%{$reset_color%}"
VIM_INSERT=""
RPROMPT="$VIM_INSERT"
function zle-keymap-select {
	RPROMPT="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
	zle reset-prompt
}
zle -N zle-keymap-select

# Print the time when a command is executed
preexec () {
	DATE=`date +"%H:%M:%S"`
	C=$(($COLUMNS-9))
	echo "\033[1A\033[${C}C $fg_bold[red]${DATE}$reset_color"
}

# -----------------
# Left Prompt
# ------------------------------------------------------------------------------
autoload -U promptinit
promptinit

#PROMPT=$'%{\e[0;92m%}%n %{\e[0;94m%}%~ %{\e[0;92m%}%# %{\e[m%}'
PROMPT="\
%{$fg_bold[green]%}%n \
%{$fg_bold[blue]%}%~ \
%{$fg_bold[green]%}%# \
%{$reset_color%}"

# -----------------
# External Resources
# ------------------------------------------------------------------------------
RESOURCES=(~/.aliases ~/.functions ~/.cgrc ~/bin/z.sh)
for FILE in $RESOURCES; do
	if [ -f $FILE ]; then
		source $FILE
	fi
done

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# -----------------
# Dirstack
# ------------------------------------------------------------------------------
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
	[[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
	print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

# Remove duplicate entries
setopt pushdignoredups

# This reverts the +/- operators.
setopt pushdminus

