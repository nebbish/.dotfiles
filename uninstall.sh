#!/usr/bin/env bash

for d in bash bin_files devstuff git p4 screen vim; do
	echo "Unstowing $d ..."
	stow -D $d
done

