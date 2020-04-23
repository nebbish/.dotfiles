#!/usr/bin/env bash

for d in bash bin_files devstuff git screen vim; do
	echo "Unstowing $d ..."
	stow -D $d
done

