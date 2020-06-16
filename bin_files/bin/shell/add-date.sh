#!/bin/bash

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <filename>\nReads the mod time of <filename> and appends it as: '_%Y_%m_%d_%H_%M_%S'"
	exit 1
fi

gdate >/dev/null 2>&1 && tool=gdate || tool=date
dt=$($tool +"%Y_%m_%d_%H_%M_%S" -r $1)
echo -e "Renaming:  '$1' to '$1_${dt}'"
mv $1 "$1_${dt}"

