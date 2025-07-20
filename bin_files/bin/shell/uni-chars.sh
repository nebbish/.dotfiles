#!/bin/bash

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname [<file>] <filt>\nReads <file> of Unicode data (default 'UnicodeData.txt') and prints out entries where '<category> =~ <filt>' is true"
	exit 1
fi

file=
filt=

for arg in "$@"; do
	if [ ! -z "$arg" ]; then
		if [ -f "$arg" ] || [ -p "$arg" ]; then
			echo "Arg [$arg] is detected as a file"
			if [ ! -z "$file" ]; then
				echo "Source file already specified on cmd-line:  $file"
				exit 1
			fi
			file=$arg
		else
			echo "Arg [$arg] is NOT detected as a file"
			if [ ! -z "$filt" ]; then
				echo "Category filter specified on cmd-line:  $filt"
				exit 1
			fi
			filt=$arg
		fi
	fi
done

if [ -z "$file" ]; then
	file=~/bin/shell/UnicodeData.txt
fi

# Because we use =~, `shopt` is the ONLY way to be case INsensetive
shopt -s nocasematch
while IFS=';' read number name category rest; do
	if [ ! -z "$filt" ]; then
		if ! [[ "$name" =~ $filt ]]; then
			continue;
		fi
	fi
	#if [[ "$category" =~ Ps|Pe|Pi|Pf ]]; then
        printf "%-2s - (%2s, U+%8s) - %s\n" "$(perl -Mutf8 -e 'binmode(STDOUT, ":utf8"); print chr(hex("'"$number"'"))')" "$category" "$number" "$name"
	#fi
done < "$file"
shopt -u nocasematch  # turn off the option after use
