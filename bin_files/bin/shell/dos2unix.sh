#!/bin/sh

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <dir>\nRun 'find <dir> -type f -exec ...' to look for dos line endings, and IN PLACE converting to unix"
	exit 1
fi

find $1 -type f -exec grep -PIl '\r' {} \; -exec perl -pi -e 's/\r\n/\n/' {} \;

