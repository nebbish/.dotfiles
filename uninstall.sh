#!/usr/bin/env bash

for d in allshells bash bin_files config devstuff git p4 screen vim zshell; do
	echo "Unstowing $d ..."
	stow -D $d
done

##
## Unstow this last -- so the 'global stow ignore' is in place for all of the above
## (not sure if this is necessary)
##
for d in stow_files; do
	echo "Unstowing $d ..."
	stow -D $d
done

