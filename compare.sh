#!/bin/sh

dotdir=~/.dotfiles
files=$(ls -A $dir)
ignore="compare.sh"

for file in $files; do
	if [ ! -h ~/$file ] && [ $file != $ignore ]; then
		diff -rq $HOME/$file $dotdir/$file
	fi
done


