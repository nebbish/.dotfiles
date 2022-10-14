#!/usr/bin/env bash

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

