# -----------------
# External Resources
# ------------------------------------------------------------------------------
RESOURCES=($HOME/.env $HOME/.aliases $HOME/.functions $HOME/.cgrc $HOME/bin/z.sh $HOME/.private)
for FILE in $RESOURCES; do
  [[ -f "$FILE" ]] && source "$FILE"
done

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
autoload -Uz compinit
compinit

# Teamocil completion
[[ -d $HOME/.teamocil ]] && compctl -g "$HOME/.teamocil/*(:t:r)" teamocil

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

PROMPT="\
%{$fg_bold[green]%}%n \
%{$fg_bold[blue]%}%~ \
%{$fg_bold[green]%}%# \
%{$reset_color%}"

# -----------------
# Dirstack
# ------------------------------------------------------------------------------
DIRSTACKDIR="$HOME/.cache/zsh"
mkdir -p $DIRSTACKDIR
DIRSTACKFILE="$DIRSTACKDIR/dirs"
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

# -----------------
# Miscellaneous
# ------------------------------------------------------------------------------
# Use vim-like bindings
bindkey -v

# Reduce mode switch lag
export KEYTIMEOUT=3
