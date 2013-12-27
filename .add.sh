#!/bin/bash

dotdir=~/dotfiles
files=$@

for file in $files; do
	# basename = ?
	# mkdir -p ($file - $basename)
	# mv $file $dotdir/($file - $basename)

	echo "Moving $file from ~/ to $dotdir/${file:1}"
    mv $file $dotdir/${file:1}
    ln -s $dotdir/${file:1} ~/$file
done
