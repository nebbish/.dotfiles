#!/usr/bin/env bash

for d in allshells bash bin_files devstuff git p4 screen vim zshell; do
	echo "Unstowing $d ..."
	stow -D $d
done

