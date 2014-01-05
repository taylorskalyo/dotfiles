#!/bin/bash

# install.sh
# Symlinks files from ~/dotfiles/ to ~/
# 
# Files in ~/dotfiles/ stored as "filename" are converted to ".filename" in ~/
# Supports partial directory linking (e.g. ~/.config can have both symlinked
#+ and non-symlinked files).
#
# ----------------------------------------------------------------------------  

## Variables
dotdir=~/dotfiles
olddotdir=~/dotfiles_old

# create a stack of file subpaths called files
for f in $(ls $dotdir); do
	files[${#files[*]}]=$f
done
height=${#files[@]}

# ----------------------------------------------------------------------------

# while the stack is not empty, processes the files
while [ $height -gt 0 ]; do

	# pop file from stack
	let "height -= 1"
	file=${files[height]}
	unset files[$height]
	
	# if the file is a directory in ~/dotfiles/ ... 
	if [ -d $dotdir/$file ]; then

		# if it exists as a directory in ~/...
		if [ -e ~/.$file ] && [ -d ~/.$file ]; then
			# create a directory with the same name in ~/dotfiles_old/, so
			#+ that its files can be backed up there
			mkdir -p $olddotdir/.$file
		fi

		# recreate it in ~/
		mkdir -p ~/.$file

		# push the files in the directory to the stack
		for f in $(ls $dotdir/$file); do
			files[${#files[*]}]=$file/$f
		done
		height=${#files[@]}
	fi

	# if a file exists in ~/ and is not a symlink or a directory...
	if [ -e ~/.$file ] && [ ! -h ~/.$file ] && [ ! -d ~/.$file ]; then

		# move it to ~/dotfiles_old/
		echo "Moving $file from ~/ to $olddotdir/"
		mkdir -p $olddotdir
		mv ~/.$file $olddotdir/.$file
	fi

	# if the file does not exist in ~/ ...
	if [ ! -e ~/.$file ]; then

		# link the file
		echo "Linking $file from $dotdir/ to ~/"
		ln -s $dotdir/$file ~/.$file
	fi
done
