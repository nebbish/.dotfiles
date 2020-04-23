#!/bin/bash

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <dir>\nRun forever, and list contents of <dir> every 60 seconds (trying to keep SSHFS mounts alive)"
	exit 1
fi

targ=$1
if [ ! -d "$targ" ]; then
	echo "Invalid argument [$1], a valid directory must be specified"
	exit 1
fi

idx=0
delay=60
while [ 1 ]; do
	ls -la $targ/* >/dev/null 2>&1
	if [ ! -d "$targ" ]; then
		echo "The target seems to have disappeared, quiting"
		exit 0
	fi

	dt=$(date +"%Y-%m-%d %H:%M:%S")
	echo "$dt, iteration $idx, keeping [$targ] alive"

	idx=$((idx + 1))
	sleep $delay
done

