#!/bin/bash

# simple-install.sh
# Symlinks files from ~/dotfiles/ to ~/
# 
# Files in ~/dotfiles/ stored as "filename" are converted to ".filename" in ~/
#
# ----------------------------------------------------------------------------

## Variables
dir=~/dotfiles
olddir=~/dotfiles_old
files=$(ls $dir)

# ----------------------------------------------------------------------------

# create ~/dotfiles_old/ in ~/
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir

cd $dir

# move any existing dotfiles in ~/ to ~/dotfiles_old/ directory, then create
#+ symlinks
for file in $files; do
	if [ -e ~/.$file ]; then
		echo "Moving $file from ~ to $olddir"
		mv ~/.$file ~/dotfiles_old/
	fi
	echo "Linking $file from $dir to ~"
	ln -s $dir/$file ~/.$file
done
