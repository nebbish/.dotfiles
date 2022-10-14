#!/usr/bin/env bash

if [[ -n $2 ]]; then
    dest=$2
else
    dest=${1}.gpg
fi

gpg --cipher-algo aes256 -c -o $dest $1

