#!/bin/bash

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <arg>\nJust echos back out stuff to test arrays in a bash script"
	exit 1
fi

levels=(low med high)
modes=(fast deep)
sample=$1

for lvl in "${levels[@]}"; do
	for mode in "${modes[@]}"; do
		echo "Testing: --level ${lvl} --mode ${mode}, target arg:  ${sample}"
		echo
	done
done

