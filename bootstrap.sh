#!/usr/bin/env bash

##
## TODO setup the 'yum' or 'homebrew' sections based on OS
##
##     yum steps:
##         * install epel-release repo
##         * install nux-dextop repo (see: https://unix.stackexchange.com/a/395827/194787)
##

##
## Stow the "stow_files" package first -- it sets up the 'global stow ignore'
##
for d in stow_files; do
	echo "Stowing $d ..."
	stow -R $d "$@"
done


##
## Now stow all the packages that can be folded
##
for d in allshells bash bin_files devstuff git p4 screen tmux zshell; do
	echo "Stowing $d ..."
	stow -R $d "$@"
done

##
## Now the packages that should NOT be folded
##
##    vim/.vim:
##        it is typically created and maintained by VIM upon first launch
##
##    config/.config: 
##        a few tools expect to drop files here
##
for d in config vim; do
	echo "Stowing $d ..."
	stow --no-folding -R $d "$@"
done

