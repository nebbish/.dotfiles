#!/bin/sh

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <filename>\nReads the mod time of <filename> and appends it as: '_%Y_%m_%d_%H_%M_%S'"
	exit 1
fi

dt=$(date +"%Y_%m_%d_%H_%M_%S" -r $1)
echo -e "Renaming:  '$1' to '$1_${dt}'"
mv $1 "$1_${dt}"

