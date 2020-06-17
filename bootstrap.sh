#!/usr/bin/env bash

##
## TODO setup the 'yum' or 'homebrew' sections based on OS
##
##     yum steps:
##         * install epel-release repo
##         * install nux-dextop repo (see: https://unix.stackexchange.com/a/395827/194787)
##

for d in allshells bash bin_files devstuff git p4 screen vim zshell; do
	echo "Stowing $d ..."
	stow -R $d "$@"
done

