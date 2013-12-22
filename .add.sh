#!/bin/bash

dir=~/dotfiles
files=$@

for file in $files; do
    mv $file $dir/${file:1}
    ln -s $dir/${file:1} ~/$file
done
