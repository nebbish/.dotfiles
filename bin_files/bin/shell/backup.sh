#!/usr/bin/env bash

if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <src> <dst>\nBacks up <src> to <dst> via rsync and 'in-flight' tar'ing"
	exit 1
fi

src=$(realpath -e $1)
dst=$(realpath -m $2)

echo -e "Backing up directory..."
echo -e "  SRC:  $src"
echo -e "  DST:  $dst"

if [ ! -d $src ]; then
	echo -e "ERROR:  the specified source [$src] is not a directory"
	exit 1
fi
if [ ! -d $dst ]; then
	echo -e "NOTE:  the destination [$dst] did not exist, creating it now"
	mkdir $dst
fi

#
# Before doing anything, save the current directory
#
curdir=$(pwd)

#
# First, run an "in-flight" tar operation for the main backup maneuver
#
(cd $src; tar cf - .) | (cd $dst; tar xpf -)

#
# Then adjust the $src value to end in a trailing slash
#
# NOTE:  the space before the '-1' is necessary to prevent the substitution
#        from appearing like the "default value" type of substitution
#        i.e. ${f:-default}
#
if [ ! "${src: -1}" = "/" ]; then
	src=$src/
fi

#
# Finally, run a "rsync" for the follow up maneuver
#
# NOTE:  for "rsync" the trailing slash is important on the "src" value.
#        because the "dst" passed in is expected to also be the full
#        destination path
#
# From the man page, the following two commands are equivalent:
#		rsync -av /src/foo /dest
#		rsync -av /src/foo/ /dest/foo
cd $dst; rsync -avPHSx --delete $src .

#
# Then restore the current directory
#
cd $curdir

