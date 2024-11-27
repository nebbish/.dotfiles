#!/usr/bin/env bash

if [[ $# == 0 ]]; then
    echo 'Usage:  decrypt src [dest]'
    echo '  if not provided, default [dest] will be:'
    echo '      <src> with '\''.gpg'\'' extension stripped (if present), or'
    echo '      <src> with '\''.pgp'\'' extension stripped (if present), or'
    echo '      <src>.out'
    return 2>/dev/null || exit
fi

if [[ -n $2 ]]; then
    dest=$2
elif [[ ${1%.gpg} != $1 ]]; then
    dest=${1%.gpg}
elif [[ ${1%.pgp} != $1 ]]; then
    dest=${1%.pgp}
else
    dest=$1.out
fi

gpg -o $dest -d $1

