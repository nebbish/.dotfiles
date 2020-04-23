#!/bin/sh

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <file> [<tag>]\nRuns 'nm -g <file>' and 'nm -D <file>' saving the output with names that will include <tag>"
	exit 1
fi

arg_dir=${1%/*}
arg_file=${1##*/}
arg_title=${arg_file%.*}

flare=$2

echo "nm -g $1 > $flare-$arg_title-exports.txt"
nm -g $1 > $flare-$arg_title-exports.txt
echo "nm -D $1 > $flare-$arg_title-dynamic.txt"
nm -D $1 > $flare-$arg_title-dynamic.txt

