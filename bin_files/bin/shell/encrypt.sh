#!/usr/bin/env bash

if [[ $# == 0 ]]; then
    echo 'Usage:  encrypt src [dest]'
    echo '  if not provided, default [dest] will be <src>.gpg'
    return 2>/dev/null || exit
fi

if [[ -n $2 ]]; then
    dest=$2
else
    dest=${1}.gpg
fi

gpg --cipher-algo aes256 -c -o $dest $1

