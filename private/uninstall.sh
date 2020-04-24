#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
stowdir="$( dirname "$dir" )"
dname="$( basename "$dir" )"
echo "Unstowing $dname ..."
stow -D -d $stowdir $dname

