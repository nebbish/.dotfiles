#!/usr/bin/env bash

##
## TODO setup the 'yum' or 'homebrew' sections based on OS
##
##     yum steps:
##         * install epel-release repo
##         * install nux-dextop repo (see: https://unix.stackexchange.com/a/395827/194787)
##

for d in bash bin_files devstuff git screen vim; do
	echo "Stowing $d ..."
	stow -R $d "$@"
done

